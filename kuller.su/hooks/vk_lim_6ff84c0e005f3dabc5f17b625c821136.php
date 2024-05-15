<?php

class vk_lim
{
	public function getOutput()
	{
        if( IPSLib::loginMethod_enabled('vkontakte') === true )
        {
            return ipsRegistry::instance()->output->getTemplate('vkontakte')->vkServicesLim();
        }
	}
}