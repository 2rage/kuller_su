<?php
/**
 * Invision Power Services
 * IP.Board v3.0.0
 * Upgrader: Database Convertion
 *
 * @author 		Tony
 * @copyright	(c) 2009 IBResource.ru
 * @license		http://www.invisionpower.com/community/board/license.html
 * @package		Invision Power Board
 * @link		http://www.invisionpower.com
 *
 */

class upgrade_convert extends ipsCommand
{
	/**
	 * Execute selected method
	 *
	 * @access	public
	 * @param	object		Registry object
	 * @return	void
	 */
	public function doExecute( ipsRegistry $registry ) {

        // uncomment to skip this step
        //$this->registry->autoLoadNextAction( 'apps' );

        if( strtolower( $this->settings['sql_driver'] ) == 'mysql' ) {

            $utf8_ok = FALSE;
            $table_prefix = $this->registry->dbFunctions()->getPrefix(); // PREFIX CAN BE EMPTY !

            $this->DB->return_die       = 1;
            $this->DB->allow_sub_select = 1;
            $this->DB->error			= '';

            if( substr( $this->DB->getSqlVersion(), 0, 1 ) >= 5 ) {
                $query = "SELECT table_collation FROM INFORMATION_SCHEMA.TABLES WHERE table_schema = '{$this->settings['sql_database']}' AND table_name LIKE '{$table_prefix}%'";

                $this->DB->query( $query );

                if ( $this->DB->error ) {
                    $this->registry->output->addError( nl2br( $query ) . '<br /><br />' . $this->DB->error );
                }
                else {

                    $utf8_ok = TRUE;

                    while( $r = $this->DB->fetch() ) {

                        if ( strpos( $r['table_collation'], 'utf8' ) !== 0 ) {
                            $utf8_ok = FALSE;
                            break;
                        }
                    }
                }
            }
            else {
                $tables = Array( 'posts', 'forums' );

                foreach( $tables as $table ) {

                    $table = $table_prefix . $table;
                    $query = 'SHOW CREATE TABLE ' . $table;

                    $this->DB->query( $query );

                    if ( $this->DB->error ) {
                        $this->registry->output->addError( nl2br( $query ) . '<br /><br />' . $this->DB->error );
                        $utf8_ok = FALSE;
                        break;
                    }

                    $code = $this->DB->fetch();

                    if ( preg_match( '/ DEFAULT CHARSET=utf8/', $code['Create Table'] )) {
                        $utf8_ok = TRUE;
                    }
                    else {
                        $utf8_ok = FALSE;
                    }
                }
            }

            if( $utf8_ok ) {
                $this->registry->autoLoadNextAction( 'apps' );
            }
            else {
                $this->registry->output->setNextAction( '' );
                $this->registry->output->setHideButton( TRUE );
                $this->registry->output->setTitle( 'Конвертация базы данных' );
                $this->registry->output->addContent( $this->registry->output->template()->page_convert() );
                $this->registry->output->sendOutput();
            }
        }
        else {
            $this->registry->autoLoadNextAction( 'apps' );
        }
    }
}
