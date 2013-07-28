class Palettes {

  ArrayList<color[]> colors = new ArrayList<color[]>();
  int currentPalette = 0;

  public Palettes() {
    // http://design-seeds.com/
    colors.add(colorsFromList(#3A3D40, #1D1D1D, #D14A31, #C7C6C1, #C9D04F, #718E15));
    colors.add(colorsFromList(#E0E0D7, #E1CB72, #9A7652, #424032, #3D7F3C, #8DC876));
    colors.add(colorsFromList(#CEAC7C, #B34245, #7A0024, #312927, #304614, #8B766F));
    colors.add(colorsFromList(#F2B774, #FB6084, #FB0029, #391E21, #56528E, #A197C2));
    colors.add(colorsFromList(#597A74, #6D0D00, #A5BB3C, #3E514C, #DF212F, #1A3419));
    colors.add(colorsFromList(#D7E1F0, #263165, #56B3A9, #4674C1, #2F565C, #CCC5BA));
    colors.add(colorsFromList(#EFF0D8, #EFF0D8, #EFF0D8, #EFF0D8, #0A0831, #A7A6C3));
    colors.add(colorsFromList(#313031, #313031, #D2FFDA, #47464C, #7195A8, #A09CAB));
    colors.add(colorsFromList(#EBCDE7, #BA3424, #2FA5A2, #EC7B00, #4E402E, #B2D68C));
    colors.add(colorsFromList(#AFF470, #4B4747, #FC6F44, #45B57E, #F10A36, #F2D863));
    colors.add(colorsFromList(#EDEEBE, #EC7A0B, #776573, #EECC63, #D45800, #D2CAD1));
    colors.add(colorsFromList(#2C575C, #202751, #A952B8, #16262E, #5A1984, #E6DDC0));
    colors.add(colorsFromList(#474447, #605A5F, #CCC8C9, #1C171B, #878282, #E0E0E0));
    colors.add(colorsFromList(#A8E3E3, #315D60, #6C5064, #4DB3AC, #1B1F1F, #C98F6C));
  }
  
  public void nextColor(){
    currentPalette = (currentPalette < colors.size()-1) ? currentPalette + 1 : 0;
  }

  public color[] colorsFromList(color... args) {
    color[] colorList = new color[args.length];
    for (int i = 0; i < args.length; i++) {
      colorList[i] = args[i];
    }
    return colorList;
  }
}

