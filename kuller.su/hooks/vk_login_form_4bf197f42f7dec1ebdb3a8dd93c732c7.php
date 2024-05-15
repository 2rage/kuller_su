<?php

class vk_login_form
{
	public function getOutput()
	{
        if( IPSLib::loginMethod_enabled('vkontakte') === true )
        {
            return ipsRegistry::instance()->output->getTemplate('vkontakte')->vkInlineLogInService();
        }
	}
}