<?php

/**
 * <pre>
 * Invision Power Services
 * IP.Board v3.4.2
 * Poll voting
 * Last Updated: $Date: 2012-11-06 04:19:50 -0500 (Tue, 06 Nov 2012) $
 * </pre>
 *
 * @author 		$Author: mmecham $
 * @copyright	(c) 2001 - 2009 Invision Power Services, Inc.
 * @license		http://www.invisionpower.com/company/standards.php#license
 * @package		IP.Board
 * @subpackage	Forums
 * @link		http://www.invisionpower.com
 * @since		20th February 2002
 * @version		$Revision: 11558 $
 *
 */

if ( ! defined( 'IN_IPB' ) )
{
	print "<h1>Incorrect access</h1>You cannot access this file directly. If you have recently upgraded, make sure you upgraded all the relevant files.";
	exit();
}

class public_forums_extras_vote extends ipsCommand
{
	/**
	 * Topic data
	 *
	 * @var		array
	 */
	public $topic		= array();

	/**
	* Class entry point
	*
	* @param	object		Registry reference
	* @return	@e void		[Outputs to screen/redirects]
	*/
	public function doExecute( ipsRegistry $registry )
	{
		/* Security Check */
		if ( $this->request['secure_key'] != $this->member->form_hash )
		{
			$this->registry->output->showError( 'topic_cannot_vote', 103148, null, null, 403 );
		}
		
		//-----------------------------------------
		// INIT
		//-----------------------------------------
		
		if( !intval( $this->memberData['g_vote_polls'] ) )
		{
			$this->registry->output->showError( 'topic_cannot_vote', 10349, null, null, 403 );
		}
		
		$this->registry->class_localization->loadLanguageFile( array( 'public_topic' ) );
		
		//-----------------------------------------
		// Get data
		//-----------------------------------------

		$topic_id  = intval($this->request['t']);
		
		//-----------------------------------------
		// Make sure we have a valid poll id
		//-----------------------------------------
		
		if ( ! $topic_id )
		{
			$this->registry->output->showError( 'topics_no_tid', 10350, null, null, 404 );
		}
		
		//-----------------------------------------
		// Load the topic and poll
		//-----------------------------------------
		
		$this->topic = $this->DB->buildAndFetch( array( 
														'select'	=> 'p.pid as poll_id,p.*',
														'from'		=> array( 'polls' => 'p' ),
														'where'		=> 't.tid=' . $topic_id,
														'add_join'	=> array(
																			array( 
																				'select'	=> 't.*',
																				'from'		=> array( 'topics' => 't' ),
																				'where'		=> 't.tid=p.tid',
																				'type'		=> 'left'
																				),
																			array( 
																				'select'	=> 'f.allow_pollbump',
																				'from'		=> array( 'forums' => 'f' ),
																				'where'		=> 'f.id=t.forum_id',
																				'type'		=> 'left'
																				) ) 
												)		);
		
		//-----------------------------------------
		// No topic?
		//-----------------------------------------
		
		if ( ! $this->topic['tid'] )
		{
			$this->registry->output->showError( 'topics_no_tid', 10351, null, null, 404 );
		}

		//-----------------------------------------
		// Locked topic?
		//-----------------------------------------

		if ( $this->topic['state'] != 'open' )
		{
			$this->registry->output->showError( 'topic_vote_locked', 10352, true, null, 403 );
		}

		//-----------------------------------------
		// Have reply permissions??
		//-----------------------------------------

		$cache = $this->registry->class_forums->forum_by_id;
		
		if ( $this->registry->permissions->check( 'reply', $cache[ $this->topic['forum_id'] ] ) == FALSE )
		{
			$this->registry->output->showError( 'topic_vote_noreply', 10353, null, null, 403 );
		}

		//-----------------------------------------
		// What we doing?
		//-----------------------------------------
		
		switch( $this->request['do'] )
		{
			default:
			case 'add':
				$this->topicAddVoteToPoll();
			break;
			
			case 'delete':
				$this->topicDeletePollVotes();
			break;
		}
	}

	/**
	 * Add vote to poll
	 *
	 * @return	@e void
	 */
	public function topicAddVoteToPoll()
	{
		//-----------------------------------------
		// INIT
		//-----------------------------------------

		$vote_cast = array();

   		//-----------------------------------------
   		// Have we voted before?
		//-----------------------------------------
		
		$this->DB->build( array( 'select' => 'member_id',
								 'from'   => 'voters',
								 'where'  => "tid={$this->topic['tid']} and member_id=" . $this->memberData['member_id'] ) );
		$this->DB->execute();
		
		if ( $this->DB->getTotalRows() )
		{
			$this->registry->output->showError( 'topic_vote_already', 10354 );
		}
		
		//-----------------------------------------
		// Sort out the new array
		//-----------------------------------------
		
		$this->request['nullvote'] =  $this->request['nullvote'] ? $this->request['nullvote'] : 0 ;
		
		if ( !$this->request['nullvote'] )
		{
			//-----------------------------------------
			// First, which choices and ID did we choose?
			// Single option poll...
			//-----------------------------------------

			if ( is_array( $_POST['choice'] ) and count( $_POST['choice'] ) )
			{
				foreach( $_POST['choice'] as $question_id => $choice_id )
				{
					if ( ! $question_id or ! isset($choice_id) )
					{
						continue;
					}
					
					$vote_cast[ $question_id ][] = $choice_id;
				}
			}
			
			//-----------------------------------------
			// Multi vote poll
			//-----------------------------------------
			
			foreach( $_POST as $k => $v )
			{
				if ( preg_match( "#^choice_(\d+)_(\d+)$#", $k, $matches ) )
				{
					if ( $this->request[ $k ] == 1 )
					{
						$vote_cast[ $matches[1] ][] = $matches[2];
					}
				}
			}
			
			//-----------------------------------------
			// Unparse the choices
			//-----------------------------------------
			
			$poll_answers = IPSLib::safeUnserialize( stripslashes( $this->topic['choices'] ) );
			reset($poll_answers);

			//-----------------------------------------
			// Got enough votes?
			//-----------------------------------------
			
			if ( count( $vote_cast ) < count( $poll_answers ) )
			{
				$this->registry->output->showError( 'topic_vote_not_enough', 10355 );
			}
			
			//-----------------------------------------
			// Add voter
			//-----------------------------------------
			
			$this->DB->insert( 'voters', array(  'member_id'      => $this->memberData['member_id'],
												 'ip_address'     => $this->member->ip_address,
												 'tid'            => $this->topic['tid'],
												 'forum_id'       => $this->topic['forum_id'],
												 'member_choices' => serialize( $vote_cast ),
												 'vote_date'      => time(),
							)					);
										
			//-----------------------------------------
			// Loop
			//-----------------------------------------
			
			foreach ( $vote_cast as $question_id => $choice_array )
			{
				foreach( $choice_array as $choice_id )
				{
					$poll_answers[ $question_id ]['votes'][ $choice_id ]++;
					
					if ( $poll_answers[ $question_id ]['votes'][ $choice_id ] < 1 )
					{
						$poll_answers[ $question_id ]['votes'][ $choice_id ] = 1;
					}
				}
			}
			
			//-----------------------------------------
			// Save...
			//-----------------------------------------
			
			$this->topic['choices'] = addslashes( serialize( $poll_answers ) );
			
			$this->DB->update( 'polls', "votes=votes+1,choices='{$this->topic['choices']}'", "pid={$this->topic['poll_id']}", false, true );
		
			//-----------------------------------------
			// Go bump in the night?
			//-----------------------------------------
			
			if ($this->topic['allow_pollbump'])
			{
				$this->topic['last_real_post'] = $this->topic['last_real_post'] ? $this->topic['last_real_post'] : $this->topic['last_post'];				
				$this->topic['last_vote'] = time();
				$this->topic['last_post'] = time();
				
				$this->DB->update( 'topics', array( 'last_vote' => $this->topic['last_vote'], 'last_post' => $this->topic['last_post'], 'last_real_post' => $this->topic['last_real_post'] ), 'tid=' . $this->topic['tid'] );
			}
			else
			{
				$this->topic['last_vote'] = time();
				
				$this->DB->update( 'topics', array( 'last_vote' => $this->topic['last_vote'] ), 'tid=' . $this->topic['tid'] );
			}
		}
		else
		{
			//-----------------------------------------
			// Add null vote
			//-----------------------------------------
			
			$this->DB->insert( 'voters', array( 
													'member_id'  => $this->memberData['member_id'],
													'ip_address' => $this->member->ip_address,
													'tid'        => $this->topic['tid'],
													'forum_id'   => $this->topic['forum_id'],
													'vote_date'  => time(),
								)				);
		}
		
		$lang = $this->request['nullvote'] ? $this->lang->words['poll_viewing_results'] : $this->lang->words['poll_vote_added'];
		
		$this->registry->output->redirectScreen( $lang , $this->settings['base_url'] . "showtopic={$this->topic['tid']}&amp;st=" . $this->request['st'], $this->topic['title_seo'], 'showtopic' );
	}

	/**
	 * Remove votes
	 *
	 * @return	@e void
	 */
	public function topicDeletePollVotes()
	{
		//-----------------------------------------
		// Permissions check
		//-----------------------------------------
		
		if ( ! $this->settings['poll_allow_vdelete'] AND ! $this->memberData['g_is_supmod'] )
		{
			$this->registry->output->showError( 'topic_cannot_vote', 103147, null, null, 403 );
		}

		//-----------------------------------------
		// What did we vote for?
		//-----------------------------------------
		
		$voter = $this->DB->buildAndFetch( array( 'select' => '*',
										 		  'from'   => 'voters',
										 		  'where'  => "tid=" . $this->topic['tid'] . " and member_id=" . $this->memberData['member_id'] ) );
										
		if ( ! $voter )
		{
			$this->registry->output->redirectScreen( $this->lang->words['poll_vote_deleted'], $this->settings['base_url'] . "showtopic={$this->topic['tid']}&amp;st=" . $this->request['st'], $this->topic['title_seo'], 'showtopic' );
		}
		
		//-----------------------------------------
		// Ok, we're here.. delete the votes
		//-----------------------------------------
		
		$this->DB->delete( 'voters', "tid=" . $this->topic['tid'] . " and member_id=" . $this->memberData['member_id'] );
		
		//-----------------------------------------
		// Remove our votes
		//-----------------------------------------
		
		$myVotes  = IPSLib::safeUnserialize( $voter['member_choices'] );
		$pollData = IPSLib::safeUnserialize( stripslashes( $this->topic['choices'] ) );
		
		if ( is_array( $myVotes ) AND is_array( $pollData ) )
		{
			foreach( $myVotes as $_questionID => $data )
			{
				foreach( $data as $_choice )
				{
					$pollData[ $_questionID ]['votes'][ $_choice ]--;
					$pollData[ $_questionID ]['votes'][ $_choice ] = $pollData[ $_questionID ]['votes'][ $_choice ] < 0 ? 0 : $pollData[ $_questionID ]['votes'][ $_choice ];
				}
			}
		}
		
		//-----------------------------------------
		// Update
		//-----------------------------------------
		
		$update['votes']	= $this->topic['votes'] - 1;
		$update['votes']	= $update['votes'] < 0 ? 0 : $update['votes'];
		$update['choices']	= serialize( $pollData );
		
		$this->DB->update( 'polls', $update, "tid=" . $this->topic['tid'] );
		
		/* done */
		$this->registry->output->redirectScreen( $this->lang->words['poll_vote_deleted'], $this->settings['base_url'] . "showtopic={$this->topic['tid']}&amp;st=" . $this->request['st'], $this->topic['title_seo'], 'showtopic' );
	}
}
