Class FlashLightAngled : DoomWeapon replaces Chainsaw
{
  bool LightOn;

  Default
  {
    Weapon.SlotNumber 0;
    Inventory.PickupSound "misc/p_pkup";
    Inventory.PickupMessage "Picked up a flashlight!";
    Scale 0.75;
    +WEAPON.NOALERT
    +WEAPON.NOAUTOFIRE
    +WEAPON.NOAUTOAIM
    +NOTRIGGER
  }

  States
  {
  Spawn:
    FLSH A -1;
    Loop;
  Ready:
    FLIT A 1 A_WeaponReady();
    Loop;
  LightReady:
    FLIT A 0 A_Light2();
    FLIT A 1 A_WeaponReady();
    FLIT A 0 A_FireBullets( 0, 0, 1, 0, "FlashLBeam", FBF_NOFLASH | FBF_NORANDOMPUFFZ, 1500);
    Loop;
  Deselect:
    FLIT A 0 A_JumpIf(invoker.LightOn, "LightLower");
  Lower:
    FLIT A 0 A_Light0();
    FLIT A 1 A_Lower();
    Loop;
  LightLower:
    FLIT A 0 A_PlaySound("flashlight/off");
    FLIT A 0 { invoker.LightOn=false; }
  TrueLightLower:
    FLIT A 0 A_Light0();
    FLIT A 1 A_Lower();
    Loop;
  Select:
    FLIT A 1 A_Raise();
    Loop;
  Fire:
    FLIT A 1 A_JumpIf(invoker.LightOn, "LightOff");
    FLIT A 1 A_PlaySound("flashlight/on");
    FLIT A 1 A_Light2();
    FLIT A 1 { invoker.LightOn=true; }
    Goto LightReady;
  LightOff:
    FLIT A 1 A_PlaySound("flashlight/off");
    FLIT A 1 A_Light0();
    FLIT A 1 { invoker.LightOn=false; }
    Goto Ready;
  }
}

Class FlashLBeam : Actor
{
  Default
  {
    Radius 8;
    Height 8;
    Scale 1.0;
    Mass 5000;
    RenderStyle "Add";
    alpha 0.25;
    +NOGRAVITY
    +DONTSPLASH
    +NOTIMEFREEZE
    +NOBLOOD
    +ALWAYSPUFF
    +PUFFONACTORS
    +BLOODLESSIMPACT
    +NOTRIGGER
  }

  States
  {
  Spawn:
    TNT1 A 0;
    TNT1 A 1 Bright;
    Goto Death;
  Death:
    TNT1 A 1 Bright;
    Stop;
  }
}

Class FlashlightCentered : Weapon
{
  bool LightOn;

  Default
  {
    weapon.selectionorder 4000;
    Inventory.PickupSound "misc/p_pkup";
    Inventory.PickupMessage "Picked up a flashlight!";
    Scale 0.75;
    +WEAPON.NOALERT
    +WEAPON.NOAUTOFIRE
    +WEAPON.NOAUTOAIM
    +NOTRIGGER
  }

  States
  {
  Spawn:
    FLSH B -1;
    Loop;
  Ready:
    FLIT B 1 A_WeaponReady();
    Loop;
  LightReady:
    FLIT B 0 A_Light2();
    FLIT B 1 A_WeaponReady();
    FLIT B 0 A_FireBullets( 0, 0, 1, 0, "FlashLBeam", FBF_NOFLASH | FBF_NORANDOMPUFFZ, 1500);
    Loop;
  Deselect:
    FLIT B 0 A_JumpIf(invoker.LightOn, "LightLower");
  Lower:
    FLIT B 0 A_Light0();
    FLIT B 1 A_Lower();
    Loop;
  LightLower:
    FLIT B 0 A_PlaySound("flashlight/off");
    FLIT B 0 { invoker.LightOn=false; }
  TrueLightLower:
    FLIT B 0 A_Light0();
    FLIT B 1 A_Lower();
    Loop;
  Select:
    FLIT B 1 A_Raise();
    Loop;
  Fire:
    FLIT B 1 A_JumpIf(invoker.LightOn, "LightOff");
    FLIT B 1 A_PlaySound("flashlight/on");
    FLIT B 1 A_Light2();
    FLIT B 1 { invoker.LightOn=true; }
    Goto LightReady;
  LightOff:
    FLIT B 1 A_PlaySound("flashlight/off");
    FLIT B 1 A_Light0();
    FLIT B 1 { invoker.LightOn=false; }
    Goto Ready;
  }
}