import java.sql.*;
import java.util.*;
import java.util.Date;

public class Assignment2 {

   // A connection to the database
   Connection connection;

   // Can use if you wish: seat letters
   List<String> seatLetters = Arrays.asList("A", "B", "C", "D", "E", "F");
   Map<String, Integer> rowMap = new HashMap<String, Integer>();

   Assignment2() throws SQLException {

      try {
         Class.forName("org.postgresql.Driver");
      } catch (ClassNotFoundException e) {
         e.printStackTrace();
      }
   }

  /**
   * Connects and sets the search path.
   *
   * Establishes a connection to be used for this session, assigning it to
   * the instance variable 'connection'.  In addition, sets the search
   * path to 'air_travel, public'.
   *
   * @param  url       the url for the database
   * @param  username  the username to connect to the database
   * @param  password  the password to connect to the database
   * @return           true if connecting is successful, false otherwise
   */
   public boolean connectDB(String url, String username, String password) {
       try {
           connection = DriverManager.getConnection(url, username, password);
           PreparedStatement ps = connection.prepareStatement("SEARCH_PATH TO air_travel, public;"); 
           ps.executeUpdate();
       } catch (Exception e) {
           e.printStackTrace();
           return false;
       }
      // Implement this method!
      return true;
   }

  /**
   * Closes the database connection.
   *
   * @return true if the closing was successful, false otherwise
   */
   public boolean disconnectDB() {
      // Implement this method!
       if (connection != null) {
           try {
               connection.close();
           } catch (Exception e) {
               e.printStackTrace();
               return false;
           }
       }

        return true;
   }
   
   /* ======================= Airline-related methods ======================= */

   /**
    * Attempts to book a flight for a passenger in a particular seat class. 
    * Does so by inserting a row into the Booking table.
    *
    * Read handout for information on how seats are booked.
    * Returns false if seat can't be booked, or if passenger or flight cannot be found.
    *
    * 
    * @param  passID     id of the passenger
    * @param  flightID   id of the flight
    * @param  seatClass  the class of the seat (economy, business, or first) 
    * @return            true if the booking was successful, false otherwise. 
    */
   public boolean bookSeat(int passID, int flightID, String seatClass) {
      // Implement this method!
       int c1 = 0;
       int c2 = 0;
       int c3 = 0;
       int cr1 = 0;
       int cr2 = 0;
       int cr3 = 0;
       int bc = 0;
       int cc = 0;
       int mc = 0;
       int price = 0;
       try {
           String planeSql = "select plane.* from air_travel.plane, air_travel.flight where flight.airline = plane.airline and flight.plane = plane.tail_number and flight.id = ?";
           PreparedStatement planeStmt = connection.prepareStatement(planeSql);
           planeStmt.setInt(1, flightID);
           ResultSet planeRs = planeStmt.executeQuery();
           while (planeRs.next()) {
                c1 = planeRs.getInt("capacity_first");
                c2 = planeRs.getInt("capacity_business");
                c3 = planeRs.getInt("capacity_economy");
           }
           planeStmt.close();

           cr1 = getCeil(Math.ceil((double)c1 / 6));
           cr2 = getCeil(Math.ceil((double)c2 / 6));
           cr3 = getCeil(Math.ceil((double)c3 / 6));

           Map<String, Integer> rowMap = new HashMap<String, Integer>();

           rowMap.put("first", 0);
           rowMap.put("business", cr1);
           rowMap.put("economy", cr2 + cr1);
           cc = c1 + c2 + c3;
           Map<String, Integer> rowCount = new HashMap<String, Integer>();
           rowCount.put("first", c1);
           rowCount.put("business", c2);
           rowCount.put("economy", c3);

           String bookSql = "select max(id), count(id) filter (where flight_id = ? and seat_class = ?::air_travel.seat_class) from air_travel.booking";
           PreparedStatement bookStmt = connection.prepareStatement(bookSql);
           bookStmt.setInt(1, flightID);
           bookStmt.setString(2, seatClass);
           ResultSet bookRs = bookStmt.executeQuery();
           while (bookRs.next()) {
               bc = bookRs.getInt("count");
               mc = bookRs.getInt("max");
           }
           bookStmt.close();

           String priceSql = "select * from air_travel.price where flight_id = ?";
           PreparedStatement priceStmt = connection.prepareStatement(priceSql);
           priceStmt.setInt(1, flightID);
           ResultSet priceRs = priceStmt.executeQuery();
           while (priceRs.next()) {
               price = priceRs.getInt(seatClass);
           }

           priceStmt.close();


           if (bc < rowCount.get(seatClass)) {
               String addSql = "insert into air_travel.booking(id, pass_id, flight_id, datetime, price, seat_class, row, letter) values(?,?,?,?,?,?::air_travel.seat_class,?,?) ";
               PreparedStatement addStmt = connection.prepareStatement(addSql);
               addStmt.setInt(1, mc + 1);
               addStmt.setInt(2, passID);
               addStmt.setInt(3, flightID);
               addStmt.setTimestamp(4, getCurrentTimeStamp());
               addStmt.setInt(5, price);
               addStmt.setString(6, seatClass);
               int rc = getCeil(Math.ceil((double)(bc+1) / 6));
               String ll = seatLetters.get( bc % 6);
               addStmt.setInt(7, rc + rowMap.get(seatClass));
               addStmt.setString(8, ll);
               boolean ret = addStmt.execute();
               addStmt.close();
               return ret;
           } else if (seatClass.equalsIgnoreCase("economy") && bc < (rowCount.get(seatClass) + 10)) {
               String addSql = "insert into air_travel.booking(id, pass_id, flight_id, datetime, price, seat_class, row, letter) values(?,?,?,?,?,?::air_travel.seat_class,null,null) ";
               PreparedStatement addStmt = connection.prepareStatement(addSql);
               addStmt.setInt(1, mc + 1);
               addStmt.setInt(2, passID);
               addStmt.setInt(3, flightID);
               addStmt.setTimestamp(4, getCurrentTimeStamp());
               addStmt.setInt(5, price);
               addStmt.setString(6, seatClass);
               boolean ret = addStmt.execute();
               addStmt.close();
               return ret;

           }

       } catch (Exception e) {
           e.printStackTrace();
           return false;
       }
      return false;
   }

   /**
    * Attempts to upgrade overbooked economy passengers to business class
    * or first class (in that order until each seat class is filled).
    * Does so by altering the database records for the bookings such that the
    * seat and seat_class are updated if an upgrade can be processed.
    *
    * Upgrades should happen in order of earliest booking timestamp first.
    *
    * If economy passengers left over without a seat (i.e. more than 10 overbooked passengers or not enough higher class seats), 
    * remove their bookings from the database.
    * 
    * @param  flightID  The flight to upgrade passengers in.
    * @return           the number of passengers upgraded, or -1 if an error occured.
    */
   public int upgrade(int flightID) {
      // Implement this method!
       int retN = -1;
       try {
           int c1 = 0;
           int c2 = 0;
           int c3 = 0;
           int cr1 = 0;
           int cr2 = 0;
           int cr3 = 0;
           String bookSql = "select * from air_travel.booking where flight_id = ? and row is null order by datetime";
           PreparedStatement bookStmt = connection.prepareStatement(bookSql);
           bookStmt.setInt(1, flightID);
           ResultSet bookRs = bookStmt.executeQuery();
           LinkedList<Integer> nullList = new LinkedList<>();
           while (bookRs.next()) {
               nullList.add(bookRs.getInt("id"));
           }
           bookStmt.close();

           String planeSql = "select plane.* from air_travel.plane, air_travel.flight where flight.airline = plane.airline and flight.plane = plane.tail_number and flight.id = ?";
           PreparedStatement planeStmt = connection.prepareStatement(planeSql);
           planeStmt.setInt(1, flightID);
           ResultSet planeRs = planeStmt.executeQuery();
           while (planeRs.next()) {
               c1 = planeRs.getInt("capacity_first");
               c2 = planeRs.getInt("capacity_business");
               c3 = planeRs.getInt("capacity_economy");
           }
           planeStmt.close();
           cr1 = getCeil(Math.ceil((double)c1 / 6));
           cr2 = getCeil(Math.ceil((double)c2 / 6));
           cr3 = getCeil(Math.ceil((double)c3 / 6));

           Map<String, Integer> rowMap = new HashMap<String, Integer>();
           rowMap.put("first", 0);
           rowMap.put("business", cr1);
           rowMap.put("economy", cr2+cr1);



           Map<String, Integer> priceMap = new HashMap<String, Integer>();
           String priceSql = "select * from air_travel.price where flight_id = ?";
           PreparedStatement priceStmt = connection.prepareStatement(priceSql);
           priceStmt.setInt(1, flightID);
           ResultSet priceRs = priceStmt.executeQuery();
           while (priceRs.next()) {
               priceMap.put("economy", priceRs.getInt("economy"));
               priceMap.put("business", priceRs.getInt("business"));
               priceMap.put("first", priceRs.getInt("first"));
           }

           if (nullList.size() > 0) {

               String businessSql = "select count(id) from air_travel.booking where seat_class= 'business' and flight_id =?";
               PreparedStatement businessStmt = connection.prepareStatement(businessSql);
               businessStmt.setInt(1, flightID);
               ResultSet businessRs = businessStmt.executeQuery();
               int bc = 0;
               while (businessRs.next()) {
                   bc = businessRs.getInt("count");
               }
               businessStmt.close();

               int rest = c2 - bc;
               while (nullList.size() > 0 && rest > 0) {
                    int nu = nullList.removeFirst();
                    String updateSql = "update air_travel.booking set price=?, seat_class=?::air_travel.seat_class, row=?, letter=? where id = ?";
                    PreparedStatement updateStmt = connection.prepareStatement(updateSql);
                    updateStmt.setInt(1, priceMap.get("business"));
                    updateStmt.setString(2, "business");
                    int rc = (int)Math.ceil((double)(c2 - rest + 1) / 6);

                    String ll = seatLetters.get((c2 - rest) % 6);
                    updateStmt.setInt(3, rc + rowMap.get("business"));
                    updateStmt.setString(4, ll);
                    updateStmt.setInt(5, nu);
                    updateStmt.execute();

                    updateStmt.close();
                    rest = rest - 1;
                    retN = retN + 1;


               }

           }


           if (nullList.size() > 0) {

               String firstSql = "select count(id) from air_travel.booking where seat_class= 'first' and flight_id = ?";
               PreparedStatement firstStmt = connection.prepareStatement(firstSql);
               firstStmt.setInt(1, flightID);
               ResultSet firstRs = firstStmt.executeQuery();
               int bc = 0;
               while (firstRs.next()) {
                   bc = firstRs.getInt("count");
               }
               firstStmt.close();

               int rest = c3 - bc;
               while (nullList.size() > 0 && rest > 0) {
                   int nu = nullList.removeFirst();
                   String updateSql = "update air_travel.booking set price=?, seat_class=?::air_travel.seat_class, row=?, letter=? where id = ?";
                   PreparedStatement updateStmt = connection.prepareStatement(updateSql);
                   updateStmt.setInt(1, priceMap.get("first"));
                   updateStmt.setString(2, "first");
                   int rc = getCeil(Math.ceil((double)(c3 - rest + 1) / 6));

                   String ll = seatLetters.get( (c3 - rest) % 6);
                   updateStmt.setInt(3, rc + rowMap.get("first"));
                   updateStmt.setString(4, ll);
                   updateStmt.setInt(5, nu);
                   updateStmt.execute();


                   updateStmt.close();
                   rest = rest - 1;
                   retN = retN + 1;


               }

           }

           String delSql = "delete from air_travel.booking where flight_id = ? and row is null";
           PreparedStatement delStmt = connection.prepareStatement(delSql);
           delStmt.setInt(1, flightID);
           delStmt.execute();
           delStmt.close();

       } catch (Exception e) {
           e.printStackTrace();
           return -1;
       }

      return retN;
   }


   /* ----------------------- Helper functions below  ------------------------- */

    // A helpful function for adding a timestamp to new bookings.
    // Example of setting a timestamp in a PreparedStatement:
    // ps.setTimestamp(1, getCurrentTimeStamp());

    /**
    * Returns a SQL Timestamp object of the current time.
    * 
    * @return           Timestamp of current time.
    */
   private java.sql.Timestamp getCurrentTimeStamp() {
      java.util.Date now = new java.util.Date();
      return new java.sql.Timestamp(now.getTime());
   }

   private int getCeil(double x) {
       return Integer.parseInt(new java.text.DecimalFormat("0").format(x));
   }

   // Add more helper functions below if desired.


  
  /* ----------------------- Main method below  ------------------------- */

   public static void main(String[] args) {
      // You can put testing code in here. It will not affect our autotester.
      System.out.println("Running the code!");
      try {

          Assignment2 as = new Assignment2();
          as.connectDB("jdbc:postgresql://127.0.0.1:5432/postgres", "postgres", "postgres");
          as.bookSeat(1, 10, "economy");
          as.bookSeat(1, 10, "economy");
          as.bookSeat(1, 10, "economy");
          as.bookSeat(1, 10, "economy");
          as.bookSeat(1, 10, "economy");
          as.upgrade(10);
          as.disconnectDB();

      } catch (Exception e) {
          e.printStackTrace();
      }
   }

}
