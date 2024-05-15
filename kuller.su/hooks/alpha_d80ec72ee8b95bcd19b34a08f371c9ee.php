<?php

class alpha
{
	public function getOutput()
	{
	    $template = ipsRegistry::instance()->output->getTemplate('mlist')->member_alpha_ru(
	        ipsRegistry::instance()->output->getTemplate('mlist')->functionData['member_list_show'][0]['url']
	    );
	    
        $js = <<<JS

				<script type='text/javascript'>
					$('alpha_switch').observe('click', function(){
							if( $('mlist_tabs_ru') )
							{
								$('mlist_tabs').toggle();
								$('mlist_tabs_ru').toggle();
							}
					} );

					$('alpha_switch_en').observe('click', function(){
							if( $('mlist_tabs') )
							{
								$('mlist_tabs').toggle();
								$('mlist_tabs_ru').toggle();
							}
					} );

JS;
        if ( ord( urldecode(ipsRegistry::$request['quickjump']) ) > 90 )
        {
            $js .= <<<JS
					$('mlist_tabs').toggle();
JS;
        }
        else
        {
            $js .= <<<JS
					$('mlist_tabs_ru').toggle();
JS;
        }
        
        $js .= <<<JS
				</script>
JS;
        
        return $template . $js;
	}
}