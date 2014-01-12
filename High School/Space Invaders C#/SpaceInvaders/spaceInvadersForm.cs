using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace SpaceInvaders
{
    // Classic Space Invaders Arcade game
    // Herman Dhak
    public partial class SpaceInvadersForm : Form
    {
        private double x, y;     // shows new position of ship
        private double bulletx, bullety; // shows new position of bullet
        private double aBx1, aBy1, aBx2, aBy2, aBx3, aBy3; // (aB = Alien Bullet) shows position of alien bullets
        private double alienx1, alieny1, alienx2, alieny2, alienx3, alieny3; // alien positions
        private int score = 0;   // player's score
        System.Media.SoundPlayer myPlayer = new System.Media.SoundPlayer(); //establish soundplayer for wav
        public SpaceInvadersForm()
        {
            InitializeComponent();
            initGame(); // starts a round
        }

        private void gameForm_Load(object sender, EventArgs e)
        {
           
        }

        private void spaceInvadersForm_KeyDown(object sender, KeyEventArgs e)
        {
            switch (e.KeyData)
            {
                case Keys.Left:
                    picShip.Image = shipPicsList.Images[1];
                    x -= 15;
                    if (x < 0)
                        x = Convert.ToDouble(this.Width - picShip.Width);
                    picShip.Location = new Point(Convert.ToInt32(x), Convert.ToInt32(y));
                    break;
                case Keys.Right:
                    picShip.Image = shipPicsList.Images[2];
                    x += 15;
                    if (x > this.Width - picShip.Width)
                        x = 0;
                    picShip.Location = new Point(Convert.ToInt32(x), Convert.ToInt32(y));
                    break;
                default:
                    break;
            } // end switch
        } // end keydown event

        private void spaceInvadersForm_KeyUp(object sender, KeyEventArgs e)
        {
            switch (e.KeyData)
            {
                case Keys.Left:
                    picShip.Image = shipPicsList.Images[0];
                    break;
                case Keys.Right:
                    picShip.Image = shipPicsList.Images[0];
                    break;
                case Keys.Space:
                    shoot();
                    break;
                default:
                    picShip.Image = shipPicsList.Images[0];
                    break;
            } // end case
        } // end keyup event

        public void initGame()
        {
            // re-initialize game
            // reset ship position
            x = 350; // in the middle
            y = 500; // at the bottom
            picShip.Location = new Point(Convert.ToInt32(x), Convert.ToInt32(y));
            picShip.Image = shipPicsList.Images[0];
            picShip.Visible = true;
            lblScore.Text = "Score: " + score;
            //reset alien positions
            Random roller = new Random();
            alienx1 = Convert.ToDouble(roller.Next(this.Width - picAlien1.Width));
            alieny1 = Convert.ToDouble(30);
            picAlien1.Visible = true;
            picAlien1.Location = new Point(Convert.ToInt32(alienx1), Convert.ToInt32(alieny1));
            picAlien1.Image = tempAlienPic11.Image;

            alieny2 = Convert.ToDouble(105); // 1 line below alien 1
            alienx2 = Convert.ToDouble(roller.Next(this.Width - picAlien2.Width));
            picAlien2.Visible = true;
            picAlien2.Image = tempAlienPic21.Image;
            picAlien2.Location = new Point(Convert.ToInt32(alienx2), Convert.ToInt32(alieny2));

            alieny3 = Convert.ToDouble(170); // 1 line below alien 2
            alienx3 = Convert.ToDouble(roller.Next(this.Width - picAlien3.Width));
            picAlien3.Visible = true;
            picAlien3.Location = new Point(Convert.ToInt32(alienx3), Convert.ToInt32(alieny3));
            picAlien3.Image = tempAlienPic31.Image;
            
            // start timers
            timerAlien1.Enabled = true;
            timerAlien2.Enabled = true;
            timerAlien3.Enabled = true;
        } // end initGame

        public void killShip()
        {
            // stop all timers
            timerAlien1.Enabled = false;
            timerAlien2.Enabled = false;
            timerAlien3.Enabled = false;
            //play a sound
            playerHit();
            //cycle through images
            picShipExp.Location = new Point(Convert.ToInt32(x + 20), Convert.ToInt32(y)); // directly on top of ship
            picShip.Visible = false;
            picShipExp.Visible = true;
            picShipExp.Image = picExp1.Image;
            shipExplodeTimer.Enabled = true;
        } // end killShip

        private void shipExplodeTimer_Tick(object sender, EventArgs e)
        {
            DialogResult answer;
            // cycle through explosion images if ship is hit
            if (picShipExp.Image == picExp1.Image)
                picShipExp.Image = picExp2.Image;
            else if (picShipExp.Image == picExp2.Image)
                picShipExp.Image = picExp3.Image;
            else if (picShipExp.Image == picExp3.Image)
                picShipExp.Image = picExp4.Image;
            else if (picShipExp.Image == picExp4.Image)
                picShipExp.Image = picExp5.Image;
            else if (picShipExp.Image == picExp5.Image)
                picShipExp.Visible = false;
            if (picShipExp.Visible == false)
            {
                picGameOver.Visible = true;
                shipExplodeTimer.Enabled = false;
                System.Console.Beep(1100, 300);
                System.Console.Beep(1000, 300);
                System.Console.Beep(900, 300);
                System.Console.Beep(700, 700);
                answer = MessageBox.Show("You failed to protect the Earth from an alien invasion. Play again?", "Game Over", MessageBoxButtons.YesNo, MessageBoxIcon.Exclamation);
                if (answer == DialogResult.Yes)
                {
                    picGameOver.Visible = false;
                    initGame();
                }
                else
                    Application.Exit();
            }
        } // end ship explode

        private void shoot()
        {
            if (timerBullet.Enabled == false)
            {
                //Console.Beep(); use if no speakers available
                //NEED TO UPDATE FILE LOCATION
                myPlayer.SoundLocation = @"C:\Users\Home\Downloads\IT programs\cs\SpaceInvaders\sounds\shoot.wav";
                myPlayer.Play();
                bullety = y - 20; // position bullet in the center of ship
                bulletx = x + 26;
                picBullet.Location = new Point(Convert.ToInt32(bulletx), Convert.ToInt32(bullety));
                picBullet.Visible = true;
                timerBullet.Enabled = true;
            }
        } // end shoot

        private void timerBullet_Tick(object sender, EventArgs e)
        {
            Rectangle rBullet = picBullet.Bounds;
            Rectangle rMenu = gameMenuStrip.Bounds;
            Rectangle rShield1 = picShield2.Bounds;
            Rectangle rShield2 = picShield3.Bounds;
            Rectangle rShield3 = picShield1.Bounds;
            Rectangle rAlien1 = picAlien1.Bounds;
            Rectangle rAlien2 = picAlien2.Bounds;
            Rectangle rAlien3 = picAlien3.Bounds;
            lblMissile.Text = "RELOADING MISSILE";
            bullety -= 12;
            picBullet.Location = new Point(Convert.ToInt32(bulletx), Convert.ToInt32(bullety));
            if (rBullet.IntersectsWith(rMenu))
            {
                timerBullet.Enabled = false;
                picBullet.Visible = false;
                lblMissile.Text = "MISSILE READY!";
            } // end intersects with rmenu

            if (rBullet.IntersectsWith(rShield1))
            {
                timerBullet.Enabled = false;
                picBullet.Visible = false;
                lblMissile.Text = "MISSILE READY!";
            } // end intersects with rshield1

            if (rBullet.IntersectsWith(rShield2))
            {
                timerBullet.Enabled = false;
                picBullet.Visible = false;
                lblMissile.Text = "MISSILE READY!";
            } // end intersects with rshield2

            if (rBullet.IntersectsWith(rShield3))
            {
                timerBullet.Enabled = false;
                picBullet.Visible = false;
                lblMissile.Text = "MISSILE READY!";
            } // end intersects with rshield3
            
            if (rBullet.IntersectsWith(rAlien1))
            {
                timerBullet.Enabled = false;
                timerAlien1.Enabled = false;
                lblMissile.Text = "MISSILE READY!";
                score += 1000;
                lblScore.Text = "Score: " + score;
                picBullet.Visible = false;
                picAlien1.Image = picTempAlienExp1.Image;
                alienHit();
                timerAlienExp1.Enabled = true;
            } // end intersects with alien1
            
            if (rBullet.IntersectsWith(rAlien2))
            {
                timerBullet.Enabled = false;
                timerAlien2.Enabled = false;
                lblMissile.Text = "MISSILE READY!";
                score += 1000;
                lblScore.Text = "Score: " + score;
                picBullet.Visible = false;
                picAlien2.Image = picTempAlienExp1.Image;
                alienHit();
                timerAlienExp2.Enabled = true;
            } // end intersects with alien2
            
            if (rBullet.IntersectsWith(rAlien3))
            {
                timerBullet.Enabled = false;
                timerAlien3.Enabled = false;
                lblMissile.Text = "MISSILE READY!";
                score += 1000;
                lblScore.Text = "Score: " + score;
                picBullet.Visible = false;
                picAlien3.Image = picTempAlienExp1.Image;
                alienHit();
                timerAlienExp3.Enabled = true;
            } // end intersects with alien3
        } // end timerbullet event

        private void timerAlien1_Tick(object sender, EventArgs e)
        {
            // move alien across screen
            alienx1 += 35;
            picAlien1.Location = new Point(Convert.ToInt32(alienx1), Convert.ToInt32(alieny1));
            // reset the x values but raise y values (enemies get closer to the ship)
            if (alienx1 > this.Width - picAlien1.Width)
            {
                alienx1 = 0;
                alieny1 += picAlien1.Height;
            }
            // change image on each tick
            if (picAlien1.Image == tempAlienPic11.Image)
                picAlien1.Image = tempAlienPic12.Image;
            else
                picAlien1.Image = tempAlienPic11.Image;
            
            // randomly shoot a bullet at the player
            Random roller = new Random();
            if (timerAB1.Enabled == false)
                if (roller.Next(10) > 6)
                {
                    aBx1 = alienx1 + 30; // position in the center of alien
                    aBy1 = alieny1 + 30;
                    alien1BulletPic.Location = new Point(Convert.ToInt32(alienx1), Convert.ToInt32(alieny1));
                    alien1BulletPic.Visible = true;
                    timerAB1.Enabled = true;
                } //end if roller
            if (picShip.Visible == false)
                timerAlien1.Enabled = false;
            Rectangle rAlien = picAlien1.Bounds;
            Rectangle rShield = picShield1.Bounds;
            if (rAlien.IntersectsWith(rShield))
                killShip();
        } // end timeralien1

        private void timerAlien2_Tick(object sender, EventArgs e)
        {
            alienx2 += 35;
            picAlien2.Location = new Point(Convert.ToInt32(alienx2), Convert.ToInt32(alieny2));
            if (alienx2 > this.Width - picAlien1.Width)
            {
                alienx2 = 0;
                alieny2 += picAlien2.Height;
            }
            if (picAlien2.Image == tempAlienPic21.Image)
                picAlien2.Image = tempAlienPic22.Image;
            else
                picAlien2.Image = tempAlienPic21.Image;

            // randomly shoot a bullet at the player
            Random roller = new Random();
            if (timerAB2.Enabled == false)
                if (roller.Next(10) > 6)
                {
                    aBx2 = alienx2 + 30; // position in the center of alien
                    aBy2 = alieny2 + 30;
                    alien2BulletPic.Location = new Point(Convert.ToInt32(alienx2), Convert.ToInt32(alieny2));
                    alien2BulletPic.Visible = true;
                    timerAB2.Enabled = true;
                } //end if roller
           if (picShip.Visible == false)
               timerAlien2.Enabled = false;
           Rectangle rAlien = picAlien2.Bounds;
           Rectangle rShield = picShield1.Bounds;
           if (rAlien.IntersectsWith(rShield))
               killShip();
        } // end timeralien2

        private void timerAlien3_Tick(object sender, EventArgs e)
        {
            alienx3 += 35;
            picAlien3.Location = new Point(Convert.ToInt32(alienx3), Convert.ToInt32(alieny3));
            if (alienx3 > this.Width - picAlien1.Width)
            {
                alienx3 = 0;
                alieny3 += picAlien3.Height;
            }
            if (picAlien3.Image == tempAlienPic31.Image)
                picAlien3.Image = tempAlienPic32.Image;
            else
                picAlien3.Image = tempAlienPic31.Image;

            // randomly shoot a bullet at the player
            Random roller = new Random();
            if (timerAB3.Enabled == false)
                if (roller.Next(10) > 6)
                {
                    aBx3 = alienx3 + 30; // position in the center of alien
                    aBy3 = alieny3 + 30;
                    alien3BulletPic.Location = new Point(Convert.ToInt32(alienx3), Convert.ToInt32(alieny3));
                    alien3BulletPic.Visible = true;
                    timerAB3.Enabled = true;
                } //end if roller
            if (picShip.Visible == false)
                timerAlien3.Enabled = false;
            Rectangle rAlien = picAlien3.Bounds;
            Rectangle rShield = picShield1.Bounds;
            if (rAlien.IntersectsWith(rShield))
                killShip();
        } // end timeralien3 

        private void timerAB1_Tick(object sender, EventArgs e)
        {
            aBy1 += 10;
            alien1BulletPic.Location = new Point(Convert.ToInt32(aBx1), Convert.ToInt32(aBy1));
            if (aBy1 > this.Height)
            {
                timerAB1.Enabled = false;
                alien1BulletPic.Visible = false;
                alien1BulletPic.Location = new Point(1000, 1000); // location off screen
            }

            //collision detection
            Rectangle rShip = picShip.Bounds;
            Rectangle rABullet = alien1BulletPic.Bounds;
            Rectangle rShield1 = picShield2.Bounds;
            Rectangle rShield2 = picShield3.Bounds;
            Rectangle rShield3 = picShield1.Bounds;
            if (rABullet.IntersectsWith(picShip.Bounds))
            {
                timerAB1.Enabled = false;
                alien1BulletPic.Visible = false;
                killShip();
            } // end if intersectswith
            if (rABullet.IntersectsWith(rShield1))
            {
                timerAB1.Enabled = false;
                alien1BulletPic.Visible = false;
            } // end if intersectswith
            if (rABullet.IntersectsWith(rShield2))
            {
                timerAB1.Enabled = false;
                alien1BulletPic.Visible = false;
            } // end if intersectswith
            if (rABullet.IntersectsWith(rShield3))
            {
                timerAB1.Enabled = false;
                alien1BulletPic.Visible = false;
            } // end if intersectswith
        } // end timerab1

        private void timerAB2_Tick(object sender, EventArgs e)
        {
            aBy2 += 10;
            alien2BulletPic.Location = new Point(Convert.ToInt32(aBx2), Convert.ToInt32(aBy2));
            if (aBy2 > this.Height)
            {
                timerAB2.Enabled = false;
                alien2BulletPic.Visible = false;
                alien2BulletPic.Location = new Point(1000, 1000); // location off screen
            }

            //collision detection
            Rectangle rShip = picShip.Bounds;
            Rectangle rABullet = alien2BulletPic.Bounds;
            Rectangle rShield1 = picShield2.Bounds;
            Rectangle rShield2 = picShield3.Bounds;
            Rectangle rShield3 = picShield1.Bounds;
            if (rABullet.IntersectsWith(picShip.Bounds))
            {
                timerAB2.Enabled = false;
                alien2BulletPic.Visible = false;
                killShip();
            } // end if intersectswith
            if (rABullet.IntersectsWith(rShield1))
            {
                timerAB2.Enabled = false;
                alien2BulletPic.Visible = false;
            } // end if intersectswith
            if (rABullet.IntersectsWith(rShield2))
            {
                timerAB2.Enabled = false;
                alien2BulletPic.Visible = false;
            } // end if intersectswith
            if (rABullet.IntersectsWith(rShield3))
            {
                timerAB2.Enabled = false;
                alien2BulletPic.Visible = false;
            } // end if intersectswith
        } // end timerab2

        private void timerAB3_Tick(object sender, EventArgs e)
        {
            aBy3 += 10;
            alien3BulletPic.Location = new Point(Convert.ToInt32(aBx3), Convert.ToInt32(aBy3));
            if (aBy3 > this.Height)
            {
                timerAB3.Enabled = false;
                alien3BulletPic.Visible = false;
                alien3BulletPic.Location = new Point(1000, 1000); // location off screen
            }

            //collision detection
            Rectangle rShip = picShip.Bounds;
            Rectangle rABullet = alien3BulletPic.Bounds;
            Rectangle rShield1 = picShield2.Bounds;
            Rectangle rShield2 = picShield3.Bounds;
            Rectangle rShield3 = picShield1.Bounds;
            if (rABullet.IntersectsWith(picShip.Bounds))
            {
                timerAB3.Enabled = false;
                alien3BulletPic.Visible = false;
                killShip();
            } // end if intersectswith
            if (rABullet.IntersectsWith(rShield1))
            {
                timerAB3.Enabled = false;
                alien3BulletPic.Visible = false;
            } // end if intersectswith
            if (rABullet.IntersectsWith(rShield2))
            {
                timerAB3.Enabled = false;
                alien3BulletPic.Visible = false;
            } // end if intersectswith
            if (rABullet.IntersectsWith(rShield3))
            {
                timerAB3.Enabled = false;
                alien3BulletPic.Visible = false;
            } // end if intersectswith
        } // end timerab3

        private void alienHit()
        {
            // if player hits an alien, play a sound
            myPlayer.SoundLocation = @"C:\Users\Home\Downloads\IT programs\cs\SpaceInvaders\sounds\invaderkilled.wav";
            myPlayer.Play();
         } // end alienHit

        private void playerHit()
        {
            // play a sound if player is hit
            myPlayer.SoundLocation = @"C:\Users\Home\Downloads\IT programs\cs\SpaceInvaders\sounds\explosion.wav";
            myPlayer.Play();
        } // end playerHit

        private void timerAlienExp1_Tick(object sender, EventArgs e)
        {
            // alternate between 2 images and then hide the picture
            if (picAlien1.Image == picTempAlienExp1.Image)
                picAlien1.Image = picTempAlienExp2.Image;
            else
            {
                picAlien1.Image = picTempAlienExp1.Image;
                picAlien1.Visible = false;
                picAlien1.Location = new Point(1000, 1000); // random location off screen
                timerAlienExp1.Enabled = false;
                checkWinner();
            } // end if else
        } // end timeralienexp1

        private void timerAlienExp2_Tick(object sender, EventArgs e)
        {
            // alternate between 2 images and then hide the picture
            if (picAlien2.Image == picTempAlienExp1.Image)
                picAlien2.Image = picTempAlienExp2.Image;
            else
            {
                picAlien2.Image = picTempAlienExp1.Image;
                picAlien2.Visible = false;
                picAlien2.Location = new Point(1000, 1000); // random location off screen
                timerAlienExp2.Enabled = false;
                checkWinner();
            } // end if else
        } // end timerexpalien4

        private void timerAlienExp3_Tick(object sender, EventArgs e)
        {
            // alternate between 2 images and then hide the picture
            if (picAlien3.Image == picTempAlienExp1.Image)
                picAlien3.Image = picTempAlienExp2.Image;
            else
            {
                picAlien3.Image = picTempAlienExp1.Image;
                picAlien3.Visible = false;
                picAlien3.Location = new Point(1000, 1000); // random location off screen
                timerAlienExp3.Enabled = false;
                checkWinner();
            } // end if else
        } // end timeralienexp3

        private void checkWinner()
        {
            DialogResult answer;
            if (timerAlien1.Enabled == false && timerAlien2.Enabled == false && timerAlien3.Enabled == false)
            {
                picGameOver.Visible = true;
                System.Console.Beep(300, 200);
                System.Console.Beep(400, 200);
                System.Console.Beep(500, 200);
                System.Console.Beep(600, 500);
                answer = MessageBox.Show("Congratulations, you have saved the Earth from the aliens. Play again?", "You win!", MessageBoxButtons.YesNo, MessageBoxIcon.Exclamation);
                if (answer == DialogResult.Yes)
                {
                    picGameOver.Visible = false;
                    initGame();
                }
                else
                    Application.Exit();
            } // end if
        } // end checkWinner
        
        private void quitToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }

        private void controlsToolStripMenuItem_Click(object sender, EventArgs e)
        {
            MessageBox.Show("Press the arrow keys to move left and right. \nPress space to shoot.", "Controls", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }

        private void aboutToolStripMenuItem_Click(object sender, EventArgs e)
        {
            MessageBox.Show("************* \n Space Invaders C# \n Version: 0.75 \n Programmed and designed by Herman Dhak \n Compiled on: 12.09.10 \n *************", "About");
        }

    } // end class SpaceInvaders
} // end namespace
