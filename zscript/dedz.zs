Class dedz : Actor
{
  Default
  {
    obituary "%o was axe-murdered by a zombie scientist.";
    health 0;
    mass 0;
    speed -1;
    Radius 0;
    Height 0;
    painchance 0;
    seesound "grunt/sight";
    painsound "grunt/pain";
    deathsound "grunt/death";
    activesound "grunt/active";
    MONSTER;
    +FLOORCLIP
  }

  States
  {
   Spawn:


    SCZA N -1;
	
	Death:

    SCZA N -1;
    stop;
	
 }
 }