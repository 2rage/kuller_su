<?php

class vk_register_form
{
	public function getOutput()
	{
        if( IPSLib::loginMethod_enabled('vkontakte') === true )
        {
            return ipsRegistry::instance()->output->getTemplate('vkontakte')->vkInlineLogInService();
        }
	}
}