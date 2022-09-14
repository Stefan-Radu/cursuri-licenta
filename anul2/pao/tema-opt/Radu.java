import java.util.Scanner;
import java.util.Arrays;
import java.util.Comparator;
import java.util.HashMap;

class Radu {

  private static class Details {

    public Details() {
      this.score = 0;
      this.goalsTo = 0;
      this.goalsFrom = 0;
    }

    public int score;
    public int goalsTo;
    public int goalsFrom;
  };

  public static void main(String[] args) {

    Scanner scanner = new Scanner(System.in);

    scanner.nextInt();
    int gamesPlayed = scanner.nextInt();
    scanner.nextLine();

    // store details for each team
    HashMap<String, Details> details = new HashMap<String, Details>();

    // read and parse
    for (int i = 0; i < gamesPlayed; ++ i) {
      String result = scanner.nextLine();
      String[] split = result.split(" ", 0);

      // get details for the two teams
      Details detOne = null;
      Details detTwo = null;

      if (details.get(split[0]) != null) {
        detOne = details.get(split[0]);
      }
      else {
        detOne = new Details();
      }

      if (details.get(split[4]) != null) {
        detTwo = details.get(split[4]);
      }
      else {
        detTwo = new Details();
      }

      // extract score
      int goalsTeamOne = Integer.parseInt(split[1]);
      int goalsTeamTwo = Integer.parseInt(split[3]);

      // update score
      if (goalsTeamOne > goalsTeamTwo) {
        detOne.score += 3;
      }
      else if (goalsTeamOne < goalsTeamTwo) {
        detTwo.score += 3;
      }
      else {
        detOne.score += 1;
        detTwo.score += 1;
      }

      // update goal count
      detOne.goalsTo += goalsTeamOne;
      detTwo.goalsFrom += goalsTeamOne;
      detTwo.goalsTo += goalsTeamTwo;
      detOne.goalsFrom += goalsTeamTwo;

      // update details
      details.put(split[0], detOne);
      details.put(split[4], detTwo);
    }
    scanner.close();

    // sort teams by score 
    String[] teams = details.keySet().toArray(new String[details.size()]);
    Arrays.sort(teams, new Comparator<String>() {
      public int compare(String a, String b) {
        return Double.compare(details.get(b).score, details.get(a).score);
      }
    }); 

    // output
    for (String team : teams) {
      Details det = details.get(team);
      System.out.println(team + 
          " " + Integer.toString(det.score) +
          " " + Integer.toString(det.goalsTo) +
          " " + Integer.toString(det.goalsFrom));
    }
  }
}
