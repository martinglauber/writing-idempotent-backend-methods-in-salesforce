public with sharing class Backend 
{
    @AuraEnabled
    public static void saveRating_0( Id movieId , Integer stars , String comments )
    {
        Rating__c RatingToSave = new Rating__c() ;

        Id UserId = UserInfo.getUserId() ;

        RatingToSave.Movie__c    = movieId  ;
        RatingToSave.User__c     = userId   ;
        RatingToSave.Stars__c    = stars    ;
        RatingToSave.Comments__c = comments ;

        list<Rating__c> ExistingUserRatings = 
            [ SELECT Id
              FROM Rating__c
              WHERE Movie__c = :movieId
                AND User__c = :UserId
            ] ;

        // delay 
        Integer i = fibonacci( 28 ) ;

        if ( ExistingUserRatings.size() > 0 )
        {
            RatingToSave.Id = ExistingUserRatings[0].Id ;
            update RatingToSave ;
        }
        else
        {
            insert RatingToSave ;
        }
    }

    @AuraEnabled
    public static void saveRating_1( Id movieId , Integer stars , String comments )
    {
        Rating__c RatingToSave = new Rating__c() ;

        Id UserId = UserInfo.getUserId() ;

        RatingToSave.Movie__c    = movieId  ;
        RatingToSave.User__c     = userId   ;
        RatingToSave.Stars__c    = stars    ;
        RatingToSave.Comments__c = comments ;
        RatingToSave.Key__c      = userId + '-' + movieId ;

        // delay 
        Integer i = fibonacci( 28 ) ;

        Database.upsert( RatingToSave , Rating__c.Key__c ) ;
    }

    @AuraEnabled
    public static void saveRating_2( Id movieId , Integer stars , String comments )
    {
        Rating__c RatingToSave = new Rating__c() ;

        Id UserId = UserInfo.getUserId() ;

        RatingToSave.Movie__c    = movieId  ;
        RatingToSave.User__c     = userId   ;
        RatingToSave.Stars__c    = stars    ;
        RatingToSave.Comments__c = comments ;

        // set lock
        String Key = UserId + '-' + movieId ;
        DatabaseLock__c Lock = new DatabaseLock__c( Key__c = Key ) ;
        insert Lock ;
        list<DatabaseLock__c> Locks = [ SELECT Id FROM DatabaseLock__c WHERE Key__c = :Key FOR UPDATE ] ;

        list<Rating__c> ExistingUserRatings = 
            [ SELECT Id
              FROM Rating__c
              WHERE Movie__c = :movieId
                AND User__c = :UserId
            ] ;

        // delay 
        Integer i = fibonacci( 28 ) ;

        if ( ExistingUserRatings.size() > 0 )
        {
            RatingToSave.Id = ExistingUserRatings[0].Id ;
            update RatingToSave ;
        }
        else
        {
            insert RatingToSave ;
        }

        // delete lock
        delete Lock ;
    }

    @AuraEnabled
    public static MovieRating[] getRatings( Id movieId )
    {
        list<MovieRating> MovieRatings = new list<MovieRating>() ;

        list<Rating__c> Ratings = 
            [ SELECT Id 
                   , User__r.Name 
                   , Stars__c 
                   , Comments__c
              FROM Rating__c 
              WHERE Movie__c = :movieId 
              WITH SECURITY_ENFORCED
              ORDER BY CreatedDate DESC
            ] ;

        for ( Integer i = 0 ; i < Ratings.size() ; i++ )
        {
            Rating__c Rating = Ratings[ i ] ;

            MovieRating MovieRating ;

            try
            {
                MovieRating = new MovieRating( 
                    '' + i
                ,   Rating?.User__r?.Name
                ,   Rating.Stars__c
                ,   Rating.Comments__c
                ) ;
            }
            catch ( Exception e )
            {
                // do nothing. Invalid movie ratings are just not returned.
            }            

            MovieRatings.add( MovieRating ) ;
        }

        return MovieRatings ;
    }

    @AuraEnabled
    public static MovieInformation getInformation( Id movieId )
    {
        String  movieName     ;
        Integer totalRatings  ;
        Decimal averageRating ; 

        list<Movie__c> Movies = 
            [ SELECT Id
                   , Name
              FROM Movie__c
              WHERE Id = :movieId
              WITH SECURITY_ENFORCED
            ] ;

        if ( Movies.size() == 0 )
        {
            return new MovieInformation( NULL , NULL , NULL ) ;
        }

        movieName = Movies[ 0 ].Name ;

        list<AggregateResult> AggregateResults = 
            [ SELECT COUNT( Id )     totalRatings
                   , AVG( Stars__c ) averageRating
              FROM Rating__c
              WHERE Movie__c = :movieId
              GROUP BY Movie__c
            ] ;

        if ( AggregateResults.size() == 0 )
        {
            return new MovieInformation( movieName , NULL , NULL ) ;
        }

        AggregateResult ar = AggregateResults[ 0 ] ;

        totalRatings = ( Integer ) ar.get( 'totalRatings' ) ;
        averageRating = ( Decimal ) ar.get( 'averageRating' ) ;

        return new MovieInformation( movieName , totalRatings , averageRating ) ;
    }

    @AuraEnabled
    public static UserRating getUserRating( Id movieId )
    {
        Id UserId = UserInfo.getUserId() ;

        list<Rating__c> Ratings = 
            [ SELECT Id 
                   , Stars__c
                   , Comments__c
              FROM Rating__c
              WHERE User__c = :UserId
                AND Movie__c = :movieId
            ] ;

        if ( Ratings.size() == 0 )
        {
            return new UserRating( NULL , NULL ) ;
        }

        Rating__c Rating = Ratings[ 0 ] ;

        return new UserRating( Integer.valueOf( Rating.Stars__c ) , Rating.Comments__c ) ;
    }

    @AuraEnabled
    public static void deleteUserRating( Id movieId )
    {
        Id UserId = UserInfo.getUserId() ;

        // set lock
        String Key = UserId + '-' + movieId ;
        DatabaseLock__c Lock = new DatabaseLock__c( Key__c = Key ) ;
        insert Lock ;
        list<DatabaseLock__c> Locks = [ SELECT Id FROM DatabaseLock__c WHERE Key__c = :Key FOR UPDATE ] ;

        delete [ SELECT Id FROM Rating__c WHERE Movie__c = :movieId AND User__c = :UserId ] ;

        // delete lock
        delete Lock ;
    }

    public class MovieInformation
    {
        @AuraEnabled public String  movieName     = 'Unknown Movie' ;
        @AuraEnabled public Integer totalReviews  = 0               ;
        @AuraEnabled public Decimal averageRating = 0.0             ;

        public MovieInformation( String movieName , Integer totalReviews , Decimal averageRating )
        {
            if ( movieName     != NULL ){ this.movieName     = movieName     ; }
            if ( totalReviews  != NULL ){ this.totalReviews  = totalReviews  ; }
            if ( averageRating != NULL ){ this.averageRating = averageRating ; }
        }
    }

    public class UserRating
    {
        @AuraEnabled public Integer stars    = 0  ;
        @AuraEnabled public String  comments = '' ;

        public UserRating( Integer stars , String comments )
        {
            if ( stars != NULL    ){ this.stars    = stars    ; }
            if ( comments != NULL ){ this.comments = comments ; }
        }
    }

    public class MovieRating
    {
        @AuraEnabled public String  index    ;
        @AuraEnabled public String  userName = 'Unknown User' ;
        @AuraEnabled public Integer stars    = 0              ;
        @AuraEnabled public String  comments = ''             ;

        public MovieRating( String key , String userName , Decimal stars )
        {
            this( key , userName , stars , NULL ) ;
        }

        public MovieRating( String index , String userName , Decimal stars , String comments )
        {
            if ( index == NULL )
            {
                throw new MovieRatingMissingKeyException() ;
            }
            else
            {
                this.index = index ;
            }

            if ( userName != NULL ){ this.userName = userName                 ; }
            if ( stars    != NULL ){ this.stars    = Integer.valueOf( stars ) ; }
            if ( comments != NULL ){ this.comments = comments                 ; }
        }
    }

    private static Integer fibonacci( Integer n )
    {
        if ( n == 1 || n == 2 )
        {
            return 1 ;
        }
        else
        {
            return fibonacci( n - 2 ) + fibonacci( n - 1 ) ;
        }
    }

    public class MovieRatingMissingKeyException extends Exception{}
}
