class Kit {
  String getKit({required String team, required String position}) {

    if(position == "Goalkeeper"){
      if(team == "ARS") {
        return "images/kits/gp_ars.png";
      } else if(team == "AVL"){
        return "images/kits/gp_asv.png";
      } else if(team == "BHA"){
        return "images/kits/gp_bha.png";
      } else if(team == "BRN"){
        return "images/kits/gp_bou.png";
      } else if(team == "BRE"){
        return "images/kits/gp_bre.png";
      } else if(team == "BUR"){
        return "images/kits/gp_bur.png";
      } else if(team == "CFC"){
        return "images/kits/gp_che.png";
      } else if(team == "CRY"){
        return "images/kits/gp_cry.png";
      } else if(team == "EVE"){
        return "images/kits/gp_eve.png";
      } else if(team == "FUL"){
        return "images/kits/gp_ful.png";
      } else if(team == "LIV"){
        return "images/kits/gp_liv.png";
      } else if(team == "LUT"){
        return "images/kits/gp_lut.png";
      } else if(team == "MCI"){
        return "images/kits/gp_mci.png";
      } else if(team == "MUN"){
        return "images/kits/gp_mnu.png";
      } else if(team == "NEW"){
        return "images/kits/gp_new.png";
      } else if(team == "NOF"){
        return "images/kits/gp_nfo.png";
      } else if(team == "SHU"){
        return "images/kits/gp_she.png";
      } else if(team == "TOT"){
        return "images/kits/gp_tot.png";
      } else if(team == "WHU"){
        return "images/kits/gp_whu.png";
      } else if(team == "WOL"){
        return "images/kits/gp_wol.png";
      } else {
        return "images/kits/gp_jersey.png";
      }
    }

    if(team == "ARS") {
      return "images/kits/ars.png";
    } else if(team == "AVL"){
      return "images/kits/asv.png";
    } else if(team == "BHA"){
      return "images/kits/bha.png";
    } else if(team == "BRN"){
      return "images/kits/bou.png";
    } else if(team == "BRE"){
      return "images/kits/bre.png";
    } else if(team == "BUR"){
      return "images/kits/bur.png";
    } else if(team == "CFC"){
      return "images/kits/che.png";
    } else if(team == "CRY"){
      return "images/kits/cry.png";
    } else if(team == "EVE"){
      return "images/kits/eve.png";
    } else if(team == "FUL"){
      return "images/kits/ful.png";
    } else if(team == "LIV"){
      return "images/kits/liv.png";
    } else if(team == "LUT"){
      return "images/kits/lut.png";
    } else if(team == "MCI"){
      return "images/kits/mci.png";
    } else if(team == "MUN"){
      return "images/kits/mnu.png";
    } else if(team == "NEW"){
      return "images/kits/new.png";
    } else if(team == "NOF"){
      return "images/kits/nfo.png";
    } else if(team == "SHU"){
      return "images/kits/she.png";
    } else if(team == "TOT"){
      return "images/kits/tot.png";
    } else if(team == "WHU"){
      return "images/kits/whu.png";
    } else if(team == "WOL"){
      return "images/kits/wol.png";
    }

    return "images/kits/jersey.png";
  }
}