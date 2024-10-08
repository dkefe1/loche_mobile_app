class StatKit {
  String getStatKit({required String team, required String position}) {

    if(position == "Goalkeeper"){
      if(team == "Arsenal") {
        return "images/kits/gp_ars.png";
      } else if(team == "Aston Villa"){
        return "images/kits/gp_asv.png";
      } else if(team == "Brighton"){
        return "images/kits/gp_bha.png";
      } else if(team == "Bournemouth"){
        return "images/kits/gp_bou.png";
      } else if(team == "Brentford"){
        return "images/kits/gp_bre.png";
      } else if(team == "Burnley"){
        return "images/kits/gp_bur.png";
      } else if(team == "Chelsea"){
        return "images/kits/gp_che.png";
      } else if(team == "Crystal Palace"){
        return "images/kits/gp_cry.png";
      } else if(team == "Everton"){
        return "images/kits/gp_eve.png";
      } else if(team == "Fulham"){
        return "images/kits/gp_ful.png";
      } else if(team == "Liverpool"){
        return "images/kits/gp_liv.png";
      } else if(team == "Luton"){
        return "images/kits/gp_lut.png";
      } else if(team == "Man City"){
        return "images/kits/gp_mci.png";
      } else if(team == "Man Utd"){
        return "images/kits/gp_mnu.png";
      } else if(team == "Newcastle"){
        return "images/kits/gp_new.png";
      } else if(team == "Nottingham"){
        return "images/kits/gp_nfo.png";
      } else if(team == "Sheffield"){
        return "images/kits/gp_she.png";
      } else if(team == "Tottenham"){
        return "images/kits/gp_tot.png";
      } else if(team == "West Ham"){
        return "images/kits/gp_whu.png";
      } else if(team == "Wolverhampton"){
        return "images/kits/gp_wol.png";
      } else {
        return "images/kits/gp_jersey.png";
      }
    }

    if(team == "Arsenal") {
      return "images/kits/ars.png";
    } else if(team == "Aston Villa"){
      return "images/kits/asv.png";
    } else if(team == "Brighton"){
      return "images/kits/bha.png";
    } else if(team == "Bournemouth"){
      return "images/kits/bou.png";
    } else if(team == "Brentford"){
      return "images/kits/bre.png";
    } else if(team == "Burnley"){
      return "images/kits/bur.png";
    } else if(team == "Chelsea"){
      return "images/kits/che.png";
    } else if(team == "Crystal Palace"){
      return "images/kits/cry.png";
    } else if(team == "Everton"){
      return "images/kits/eve.png";
    } else if(team == "Fulham"){
      return "images/kits/ful.png";
    } else if(team == "Liverpool"){
      return "images/kits/liv.png";
    } else if(team == "Luton"){
      return "images/kits/lut.png";
    } else if(team == "Man City"){
      return "images/kits/mci.png";
    } else if(team == "Man Utd"){
      return "images/kits/mnu.png";
    } else if(team == "Newcastle"){
      return "images/kits/new.png";
    } else if(team == "Nottingham"){
      return "images/kits/nfo.png";
    } else if(team == "Sheffield"){
      return "images/kits/she.png";
    } else if(team == "Tottenham"){
      return "images/kits/tot.png";
    } else if(team == "West Ham"){
      return "images/kits/whu.png";
    } else if(team == "Wolverhampton"){
      return "images/kits/wol.png";
    }

    return "images/kits/jersey.png";
  }
}