import { LightningElement , api } from 'lwc';

import STARS_URL from '@salesforce/resourceUrl/stars' ;

export default class Rating extends LightningElement 
{
    @api userName  ;
    @api comments  ;
    @api stars     ;
    @api editable  ;

    starEmptyUrl  = STARS_URL + '/empty.svg'  ;
    starFilledUrl = STARS_URL + '/filled.svg' ;

    get starStyle()
    {
        if ( this.editable )
        {
            return 'cursor : pointer; '
        }
        else
        {
            return ''
        }
    }

    get starImage_1(){ return +this.stars >= 1 ? this.starFilledUrl : this.starEmptyUrl ; }
    get starImage_2(){ return +this.stars >= 2 ? this.starFilledUrl : this.starEmptyUrl ; }
    get starImage_3(){ return +this.stars >= 3 ? this.starFilledUrl : this.starEmptyUrl ; }
    get starImage_4(){ return +this.stars >= 4 ? this.starFilledUrl : this.starEmptyUrl ; }
    get starImage_5(){ return +this.stars >= 5 ? this.starFilledUrl : this.starEmptyUrl ; }

    handle_1(){ this.handle_n( 1 ) }
    handle_2(){ this.handle_n( 2 ) }
    handle_3(){ this.handle_n( 3 ) }
    handle_4(){ this.handle_n( 4 ) }
    handle_5(){ this.handle_n( 5 ) }

    handle_n( numberOfStarsSelected )
    { 
        if ( this.editable )
        {
            this.stars = numberOfStarsSelected
        }
    }

    handleSavePressed()
    {
        let event = new CustomEvent( 'ratingselected' , { detail : this.stars } )
        this.dispatchEvent( event )
    }
}
