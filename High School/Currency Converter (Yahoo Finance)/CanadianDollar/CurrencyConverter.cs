using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;
using System.IO;
using System.Globalization;

namespace CanadianDollar
{
    // static class that contains currency codes and names
    public struct CurrencyData
    {
        private string _baseCode;
        private string _targetCode;
        private double _rate;
        
        // constructor
        public CurrencyData(string baseCode, string targetCode)
        {
            if (String.IsNullOrEmpty(baseCode))
                throw new ArgumentNullException("baseCode");

            if (String.IsNullOrEmpty(targetCode))
                throw new ArgumentNullException("targetCode");

            _baseCode = baseCode;
            _targetCode = targetCode;
            _rate = 0;
            
        } // end constructor

        
        // Current Exchange rate
        public double Rate
        {
            get { return _rate; }
            set { _rate = value; }
        }

        // Currency code to convert from
        public string BaseCode
        {
            get { return _baseCode; }
            set
            {
                if (String.IsNullOrEmpty(value))
                    throw new ArgumentException(BaseCode);
                _baseCode = value.Trim().ToUpper(CultureInfo.InvariantCulture);
            }
        }

        // Currency code to convert to
        public string TargetCode
        {
            get { return _targetCode; }
            set
            {
                if (String.IsNullOrEmpty(value))
                    throw new ArgumentException(TargetCode);
                _targetCode = value.Trim().ToUpper(CultureInfo.InvariantCulture);
            }
        }
    } // end structure
    
    // connect to the webservice and get exchange rates
    public sealed class CurrencyConverter
    {
        private const string urltemplate = "http://finance.yahoo.com/d/quotes.csv?{0}&f=sl1d1t1ba&e=.csv";
        private int _timeout = 30000;
        private int _readWriteTimeout = 30000;
        private const string paretemplate = "s={0}{1}=X";
        
        private enum DataFieldNames : byte
        {
            CurrencyCodes = 0,
            CurrentRate,
        }

        // Gets or sets the time-out value for the GetResponse and GetRequestStream methods. Default = 30 sec.
        public int Timeout
        {
            get { return _timeout; }
            set { _timeout = value; }
        }

        // Get/set a time-out when writing to or reading from a stream. Default = 30 sec.
        public int ReadWriteTimeout
        {
            get { return _readWriteTimeout; }
            set { _readWriteTimeout = value; }
        }

        // Connect to Finance!Yahoo site and get the info
        private List<CurrencyData> GetData(Uri url)
        {
            HttpWebRequest req = (HttpWebRequest)WebRequest.Create(url);

            req.Timeout = _timeout;
            req.ReadWriteTimeout = _readWriteTimeout;
       
            HttpWebResponse resp = (HttpWebResponse)req.GetResponse();
            try
            {
                Stream respStream = resp.GetResponseStream();
                try
                {
                    StreamReader respReader = new StreamReader(respStream, Encoding.ASCII);
                    try
                    {
                        char[] trimchars = new char[] { '"', '\'' };

                        List<CurrencyData> Result = new List<CurrencyData>();
                        
                        while (respReader.Peek() > 0)
                        {
                            string[] fields = respReader.ReadLine().Split(new char[] { ',' });

                            string from = fields[(int)DataFieldNames.CurrencyCodes].Trim(trimchars).Substring(0, 3);
                            string to = fields[(int)DataFieldNames.CurrencyCodes].Trim(trimchars).Substring(3, 3);

                            CurrencyData data = new CurrencyData(from, to);

                            CultureInfo culture = new CultureInfo("en-US", false);
                            data.Rate = Double.Parse(fields[(int)DataFieldNames.CurrentRate], culture);
                            Result.Add(data);
                        }

                        return Result;
                    }
                    finally
                    {
                        respReader.Close();
                    }
                }
                finally
                {
                    respStream.Close();
                }
            }
            finally
            {
                resp.Close();
            }
        }

        public void GetCurrencyData(ref CurrencyData data)
        {
            // Create the URL:
            StringBuilder urlpart = new StringBuilder();

            urlpart.AppendFormat(CultureInfo.InvariantCulture, paretemplate, data.BaseCode,
                    data.TargetCode);

            List<CurrencyData> listData = GetData(new Uri(String.Format(CultureInfo.InvariantCulture, urltemplate, urlpart.ToString())));

            if ((listData != null) && (listData.Count > 0))
                data = listData[0];
        }
        
        // Return CurrencyData by supplied Currency codes
        public CurrencyData GetCurrencyData(string source, string target)
        {
           CurrencyData data = new CurrencyData(source, target);
           
            GetCurrencyData(ref data);

            return data;
        }
    } // end class
} // end namespace
