<?php
/*
+--------------------------------------------------------------------------
|   IP.Board v3.4.2
|   ========================================
|   by Matthew Mecham
|   (c) 2001 - 2004 Invision Power Services
|   http://www.invisionpower.com
|   ========================================
|   Web: http://www.invisionboard.com
|   Email: matt@invisionpower.com
|   Licence Info: http://www.invisionboard.com/?license
+---------------------------------------------------------------------------
*/


class SQLVC
{
	public static function updateOne( $old, $field )
	{
		$DB  = ipsRegistry::DB();
		$PRE = ipsRegistry::dbFunctions()->getPrefix();

		return "UPDATE {$PRE}pfields_content p, {$PRE}member_extra m
						SET p.field_{$field['pf_id']}=m.{$old}
				WHERE p.member_id=m.id";
	}
	
	public static function updateTwo( $gender )
	{
		$DB  = ipsRegistry::DB();
		$PRE = ipsRegistry::dbFunctions()->getPrefix();

		return "UPDATE {$PRE}profile_portal pp, {$PRE}pfields_content pfc SET pfc.field_{$gender['pf_id']}='f' WHERE pp.pp_gender='female' AND pp.pp_member_id=pfc.member_id";
	}
	
	public static function updateThree( $gender )
	{
		$DB  = ipsRegistry::DB();
		$PRE = ipsRegistry::dbFunctions()->getPrefix();

		return "UPDATE {$PRE}profile_portal pp, {$PRE}pfields_content pfc SET pfc.field_{$gender['pf_id']}='m' WHERE pp.pp_gender='male' AND pp.pp_member_id=pfc.member_id";
	}
}

