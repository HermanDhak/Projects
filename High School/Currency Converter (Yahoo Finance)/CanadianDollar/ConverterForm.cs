using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Web;
using System.Configuration;

namespace CanadianDollar
{
    // this program connects to a webservice to retrieve the latest exchange rates
    // Herman Dhak
    public partial class FormConverter : Form
    {
        private double Value; 
        private double Amount = 1;
        
        public FormConverter()
        {
            InitializeComponent();
        }

        private void FormCAD_Load(object sender, EventArgs e)
        {
            comboBoxFrom.SelectedIndex = 0; // set to default
            comboBoxTo.SelectedIndex = 0; // set to default
            txtAmount.Text = "1";
        }

        private void btnUpdate_Click(object sender, EventArgs e)
        {
            if (comboBoxFrom.Text == comboBoxTo.Text)
                MessageBox.Show("The currencies cannot be the same!", "Error!", MessageBoxButtons.OK, MessageBoxIcon.Error);
            else
            {
                this.Cursor = Cursors.WaitCursor;
                try
                {
                    Amount = Convert.ToDouble(txtAmount.Text);
                }
                catch (FormatException)
                {
                    MessageBox.Show("You must enter a number!", "Error!", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    txtAmount.Text = "1";
                } // end try
                try
                {
                    CurrencyConverter cc = new CurrencyConverter();
                    CurrencyData cd = new CurrencyData(lblFrom.Text, lblTo.Text);
                    // Creates new structure and sets Base currency
                    cc.GetCurrencyData(ref cd);
                    Value = cd.Rate;
                    txtValue.Text = Convert.ToString(Value * Amount);
                    lblCode.Text = lblTo.Text; // Display the code of the currency converted
                    lblCode.Visible = true;
                }
                finally
                {
                    this.Cursor = Cursors.Default;
                }
            } // end else
        } // end btn_update

        private void comboBoxFrom_SelectedIndexChanged(object sender, EventArgs e)
        {
            // adjust the hidden labels to display only the currency code
            if (comboBoxFrom.SelectedIndex == 0)
                lblFrom.Text = "USD";
            else if (comboBoxFrom.SelectedIndex == 1)
                lblFrom.Text = "CAD";
            else if (comboBoxFrom.SelectedIndex == 2)
                lblFrom.Text = "EUR";
            else if (comboBoxFrom.SelectedIndex == 3)
                lblFrom.Text = "GBP";
            else if (comboBoxFrom.SelectedIndex == 4)
                lblFrom.Text = "AUD";
            else if (comboBoxFrom.SelectedIndex == 5)
                lblFrom.Text = "INR";
            else if (comboBoxFrom.SelectedIndex == 6)
                lblFrom.Text = "JPY";
            else if (comboBoxFrom.SelectedIndex == 7)
                lblFrom.Text = "CHF";
            else if (comboBoxFrom.SelectedIndex == 8)
                lblFrom.Text = "MXN";
            else if (comboBoxFrom.SelectedIndex == 9)
                lblFrom.Text = "HKD";
            else if (comboBoxFrom.SelectedIndex == 10)
                lblFrom.Text = "KRW";
            else if (comboBoxFrom.SelectedIndex == 11)
                lblFrom.Text = "CNY";
            else if (comboBoxFrom.SelectedIndex == 12)
                lblFrom.Text = "RUB";
            else if (comboBoxFrom.SelectedIndex == 13)
                lblFrom.Text = "XAG";
            else if (comboBoxFrom.SelectedIndex == 14)
                lblFrom.Text = "XAU";
            else if (comboBoxFrom.SelectedIndex == 15)
                lblFrom.Text = "XPD";
        }

        private void comboBoxTo_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (comboBoxTo.SelectedIndex == 0)
                lblTo.Text = "CAD";
            else if (comboBoxTo.SelectedIndex == 1)
                lblTo.Text = "USD";
            else if (comboBoxTo.SelectedIndex == 2)
                lblTo.Text = "EUR";
            else if (comboBoxTo.SelectedIndex == 3)
                lblTo.Text = "GBP";
            else if (comboBoxTo.SelectedIndex == 4)
                lblTo.Text = "AUD";
            else if (comboBoxTo.SelectedIndex == 5)
                lblTo.Text = "INR";
            else if (comboBoxTo.SelectedIndex == 6)
                lblTo.Text = "JPY";
            else if (comboBoxTo.SelectedIndex == 7)
                lblTo.Text = "CHF";
            else if (comboBoxTo.SelectedIndex == 8)
                lblTo.Text = "MXN";
            else if (comboBoxTo.SelectedIndex == 9)
                lblTo.Text = "HKD";
            else if (comboBoxTo.SelectedIndex == 10)
                lblTo.Text = "KRW";
            else if (comboBoxTo.SelectedIndex == 11)
                lblTo.Text = "CNY";
            else if (comboBoxTo.SelectedIndex == 12)
                lblTo.Text = "RUB";
            else if (comboBoxTo.SelectedIndex == 13)
                lblTo.Text = "XAG";
            else if (comboBoxTo.SelectedIndex == 14)
                lblTo.Text = "XAU";
            else if (comboBoxTo.SelectedIndex == 15)
                lblTo.Text = "XPD";
        }

        private void quitToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }

        private void aboutToolStripMenuItem_Click(object sender, EventArgs e)
        {
            MessageBox.Show("***************** \nCurrency Converter \nVersion 1.0 \nDesigned and Programmed by Herman Dhak \nCompiled on: 01/19/11 \n*****************", "About", MessageBoxButtons.OK, MessageBoxIcon.Information); 
        } 
    } // end class
} // end namespace
