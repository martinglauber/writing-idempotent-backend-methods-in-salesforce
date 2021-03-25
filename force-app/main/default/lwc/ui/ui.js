
import { LightningElement , api } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';

import saveRating_0     from '@salesforce/apex/Backend.saveRating_0'     ;
import saveRating_1     from '@salesforce/apex/Backend.saveRating_1'     ;
import saveRating_2     from '@salesforce/apex/Backend.saveRating_2'     ;
import getRatings       from '@salesforce/apex/Backend.getRatings'       ;
import getInformation   from '@salesforce/apex/Backend.getInformation'   ;
import getUserRating    from '@salesforce/apex/Backend.getUserRating'    ;
import deleteUserRating from '@salesforce/apex/Backend.deleteUserRating' ;

export default class Ui extends LightningElement 
{
    @api recordId

    averageRating
    comments
    currentPageReference
    movieTitle
    ratings 
    stars
    totalReviews

    connectedCallback()
    {
        this.refreshPage()
    }

    refreshPage()
    {
        this.getMovieInformation()
        this.getUserRating()
        this.getMovieRatings()
    }

    async getMovieInformation()
    {
        let movieId = this.recordId

        let movieInformation = await getInformation( { movieId } )

        this.movieTitle    = movieInformation.movieName
        this.averageRating = movieInformation.averageRating
        this.totalReviews  = movieInformation.totalReviews
    }

    async getUserRating()
    {
        let movieId = this.recordId

        let userRating = await getUserRating( { movieId } )

        this.stars    = userRating.stars
        this.comments = userRating.comments
    }

    async getMovieRatings()
    {
        let movieId = this.recordId
        let ratings = await getRatings( { movieId } )

        this.ratings = ratings 
    }

    async handleSaveClicked_0( event )
    {
        let movieId  = this.recordId
        let comments = this.comments
        let stars    = this.stars

        let x = await saveRating_0( { movieId , stars , comments } )

        this.refreshPage()
    }

    async handleSaveClicked_1( event )
    {
        let movieId  = this.recordId
        let comments = this.comments
        let stars    = this.stars

        let x = await saveRating_1( { movieId , stars , comments } )

        this.refreshPage()
    }

    async handleSaveClicked_2( event )
    {
        let movieId  = this.recordId
        let comments = this.comments
        let stars    = this.stars

        let x = await saveRating_2( { movieId , stars , comments } )

        this.refreshPage()
    }

    async deleteUserRating()
    {
        let movieId = this.recordId

        let x = await deleteUserRating( { movieId } )

        this.getMovieRatings()
    }

    handleStarsSelected( event )
    {
        this.stars = event.detail
    }

    handleCommentTextChanged( event )
    {
        this.comments = event.target.value
    }

}
