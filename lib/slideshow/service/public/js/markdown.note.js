

var markdown_note_new = function( opts ) {

    // use module pattern (see JavaScript - The Good Parts)

    var settings;  // NB: defaults + opts merged => settings
    
    var defaults = {
     input:         '#note',            // textarea for markdown source
     input_toggle: {
       id: '#input-toggle',
       label_black: '[ Use Black Color Theme]',
       label_white: '[ Use White Color Theme]'
     },
     
     welcome: "Welcome to Markdown. We hope you **really** enjoy using this."+
      "\n\n"+
      "Just type some [markdown](http://daringfireball.net/projects/markdown) on the left and see it on the right. *Simple as that.*"
    }


    function _debug( msg )
    {
      if(window.console && window.console.log )
        window.console.log( "[debug] " + msg );
    }

    var $input,
        $input_toggle;


    var use_white_color_theme = false;
    
    function _toggle_color_theme()
    {
   /**
     *  todo: move to addon?? out of "core"
     */
 
      use_white_color_theme = !use_white_color_theme;
      if( use_white_color_theme ) {
        $input.removeClass( 'black' );
        $input_toggle.html( settings.input_toggle.label_black );
      }
      else {
        $input.addClass( 'black' );
        $input_toggle.html( settings.input_toggle.label_white );
      }
    }


   function _init( opts )
   {
     settings = $.extend( {}, defaults, opts );
     

     $input         = $( settings.input );
     $input_toggle  = $( settings.input_toggle.id );

     $input.val( settings.welcome );

     $input_toggle.click( function() { _toggle_color_theme(); } );     
   }

   _init( opts );
   
    return { }
} // fn markdown_note_new
