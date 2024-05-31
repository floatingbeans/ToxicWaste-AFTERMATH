Class Satyr : Actor
{
  Default
  {
    Health 400;
    Radius 18;
    Height 48;
    Scale 1.1;
    Speed 30;
    PainChance 50;
    Mass 350;
    SeeSound "satyr/sight";
    PainSound "cysatyr/pain";
    DeathSound "satyr/death";
    ActiveSound "cysatyr/sight";
    HitObituary "%o was ???????? by ((&*^&^(&??????.";
    MONSTER;
    +FLOORCLIP
  }

  States
  {
  Spawn:
    STYR AB 10 A_Look();
    Loop;
  See:
    STYR AABBCCDD 3 A_Chase();
    Loop;
  Melee:
    STYR EF 6 A_FaceTarget();
    STYR G 6 A_CustomMeleeAttack(8*Random(1, 50), "Baron/Melee");
    STYR PQ 5 A_FaceTarget();
    STYR R 6 A_CustomMeleeAttack(8*Random(1, 50 ), "Baron/Melee");
    Goto See;
  Pain:
    STYR H 2;
    STYR H 2 A_Pain();
    Goto See;
  Death:
    STYR I 5;
    STYR J 5 A_Scream();
    STYR K 6;
    STYR L 7 A_Fall();
    STYR M 4;
    STYR N 4;
    STYR O -1;
    Stop;
  Raise:
    STYR ONMLKJI 8;
    Goto See;
    }
}

Class GodSatyr : Actor
{
  Default
  {
    Health 2000;
    Radius 18;
    Height 95;
    Scale 2.3;
    Speed 10;
    PainChance 50;
    Mass 350;
    SeeSound "satyr/sight";
    PainSound "cysatyr/pain";
    DeathSound "satyr/death";
    ActiveSound "cysatyr/sight";
    HitObituary "%o was mauled by a satyr.";
    MONSTER;
    +FLOORCLIP
  }

  States
  {
  Spawn:
    STYR AB 10 A_Look();
    Loop;
  See:
    STYR AABBCCDD 3 A_Chase();
    Loop;
  Melee:
    STYR EF 6 A_FaceTarget();
    STYR G 6 A_CustomMeleeAttack(8*Random(1, 50), "Baron/Melee");
    STYR PQ 5 A_FaceTarget();
    STYR R 6 A_CustomMeleeAttack(8*Random(1, 50 ), "Baron/Melee");
    Goto See;
  Pain:
    STYR H 2;
    STYR H 2 A_Pain();
    Goto See;
  Death:
    STYR I 5;
    STYR J 5 A_Scream();
    STYR K 6;
    STYR L 7 A_Fall();
    STYR M 4;
    STYR N 4;
    STYR O -1;
    Stop;
  Raise:
    STYR ONMLKJI 8;
    Goto See;
    }
}

