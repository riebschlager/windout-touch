class Palettes {
  //  public static final color[] palette1 = {
  //    #75062A, #8F0D36, #C12956, #BF2753, #470215, #A32849, #DF4E70, #E65375, #BD5167, #A0495A, #DFA5A6, #A89191, #C49694, #A78A86, #B5A8A1, #D5CEC1
  //  };
  //
  //  public static final color[] palette2 = {
  //    #B96446, #DF865A, #D79E80, #BB9980, #AB8C73, #A2846A, #E0A772, #CD9C69, #F0AC65, #D79950, #F1B566, #D3A668, #EBAF5A, #D5AE58, #F7C860, #F8D35C
  //  };

  ArrayList<color[]> colors = new ArrayList<color[]>();
  public Palettes() {
    colors.add(new color[] {
      #75062A, #8F0D36, #C12956, #BF2753, #470215, #A32849, #DF4E70, #E65375, #BD5167, #A0495A, #DFA5A6, #A89191, #C49694, #A78A86, #B5A8A1, #D5CEC1
    }
    );
  }

  public color[] colorsFromList(color... args) {
    color[] colorList = new color[args.length];
    for (int i = 0; i < args.length; i++) {
      colorList[i] = args[i];
    }
    return colorList;
  }
}

