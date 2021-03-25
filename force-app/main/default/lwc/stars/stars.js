import { LightningElement , api } from 'lwc';

import STARS_URL from '@salesforce/resourceUrl/stars' ;

export default class Stars extends LightningElement 
{
    @api stars     ;

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

    get starImage_1(){ return this.starImage( 1 ) }
    get starImage_2(){ return this.starImage( 2 ) }
    get starImage_3(){ return this.starImage( 3 ) }
    get starImage_4(){ return this.starImage( 4 ) }
    get starImage_5(){ return this.starImage( 5 ) }

    starImage( n )
    {
        return +this.stars >= n ? this.starFilledUrl : this.starEmptyUrl ; 
    }

    handleClick_1(){ this.handleClick( 1 ) ; }
    handleClick_2(){ this.handleClick( 2 ) ; }
    handleClick_3(){ this.handleClick( 3 ) ; }
    handleClick_4(){ this.handleClick( 4 ) ; }
    handleClick_5(){ this.handleClick( 5 ) ; }

    handleClick( n )
    {
        let event = new CustomEvent( 'starsselected' , { detail : n } )
        this.dispatchEvent( event )
    }
}
