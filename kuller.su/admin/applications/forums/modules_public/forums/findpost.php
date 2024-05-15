<?php

/**
 * <pre>
 * Invision Power Services
 * IP.Board v3.4.2
 * Bounces a user to the right post
 * Last Updated: $Date: 2012-12-19 14:14:10 -0500 (Wed, 19 Dec 2012) $
 * </pre>
 *
 * @author 		$Author: AndyMillne $
 * @copyright	(c) 2001 - 2009 Invision Power Services, Inc.
 * @license		http://www.invisionpower.com/company/standards.php#license
 * @package		IP.Board
 * @subpackage  Forums 
 * @link		http://www.invisionpower.com
 * @version		$Rev: 11736 $
 * @since		14th April 2004
 *
 * |   > Interesting Fact: I've had iTunes playing every Radiohead tune
 * |   > I own for about a week now. Thats a lot of repeats. Got some
 * |   > cool rare tracks though. Every album+rare+b sides = 6.7 hours
 * |   > music. Not bad. I need to get our more. No, you can't take the
 * |   > laptop with you - nerd.
 *
 */

if ( ! defined( 'IN_IPB' ) )
{
	print "<h1>Incorrect access</h1>You cannot access this file directly. If you have recently upgraded, make sure you upgraded all the relevant files.";
	exit();
}

class  public_forums_forums_findpost extends ipsCommand
{
	/**
	 * Class entry point
	 *
	 * @param	object		Registry reference
	 * @return	@e void		[redirects]
	 */
	public function doExecute( ipsRegistry $registry )
    {
		//-----------------------------------------
		// Find a post
		// Don't really need to check perms 'cos topic
		// will do that for us. Woohoop
		//-----------------------------------------
		
		$pid = intval($this->request['pid']);
		
		if ( ! $pid )
		{
			$this->registry->getClass('output')->showError( 'findpost_missing_pid', 10331, null, null, 404 );
		}
		
		/* Init */
		if ( ! $this->registry->isClassLoaded('topics') )
		{
			$classToLoad = IPSLib::loadLibrary( IPSLib::getAppDir( 'forums' ) . "/sources/classes/topics.php", 'app_forums_classes_topics', 'forums' );
			$this->registry->setClass( 'topics', new $classToLoad( $this->registry ) );
		}
		
		//-----------------------------------------
		// Get post...
		//-----------------------------------------
		
		$post = $this->registry->topics->getPostById( $pid, true, array( 'onlyViewable' => true ) );
		
		if ( ! $post['pid'] )
		{
			/* Could not get the post (could be hidden, could be deleted, could be stolen by ninja aliens) */
			if ( $this->request['t'] )
			{
				$topic = $this->registry->topics->getTopicById( $this->request['t'] );
				
				if ( $topic['tid'] )
				{
					/* Got access? */
					if ( $this->registry->getClass('class_forums')->forumsCheckAccess( $topic['forum_id'], 0, 'topic', $topic, TRUE ) )
					{
						/* Redirect to page 1 of this topic */
						$url = $this->registry->output->buildSEOUrl( "showtopic=" . $topic['tid'], 'public', $topic['title_seo'], 'showtopic' );
		
						$this->registry->getClass('output')->silentRedirect( $url, false, true );
					}
				}
			}
			
			/* Nah, just dump it 'den */
			$this->registry->getClass('output')->showError( 'findpost_missing_topic', 10332, null, null, 404 );
		}
		
		/* Check permission */
		if ( ! $this->registry->getClass('class_forums')->forumsCheckAccess( $post['forum_id'], 0, 'topic', $post, TRUE ) )
		{
			$this->registry->getClass('output')->showError( 'findpost_missing_topic', 10332.1, null, null, 403 );
		}
		
		$pageUrlParam = '&page=' . $this->registry->getClass('topics')->postToPage( $post );

		$url = $this->registry->output->buildSEOUrl( "showtopic=" . $post['topic_id'] . "{$pageUrlParam}" . "&#entry" . $pid, 'public', $post['title_seo'], 'showtopic' );
		
		$this->registry->getClass('output')->silentRedirect( $url, false, true );
 	}
}