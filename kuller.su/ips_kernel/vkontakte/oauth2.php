<?php
require_once( dirname(__FILE__) . '/OAuth2Client.php' );

class vkClient extends OAuth2Client
{
    
    private $_allowed_scopes = array(
        'notify',       // Пользователь разрешил отправлять ему уведомления.
        'friends',      // Доступ к друзьям.
        'photos',       // Доступ к фотографиям.
        'audio',        // Доступ к аудиозаписям.
        'video',        // Доступ к видеозаписям.
        'notes',        // Доступ заметкам пользователя.
        'pages',        // Доступ к wiki-страницам.
        'offers',       // Доступ к предложениям (устаревшие методы).
        'questions',    // Доступ к вопросам (устаревшие методы).
        'wall',         // Доступ к обычным и расширенным методам работы со стеной.
        'messages',     // (для Standalone-приложений) Доступ к расширенным методам работы с сообщениями.
        'offline',      // Доступ к API в любое время со стороннего сервера.  
    );
    
    public function __construct($config = array()) 
    {
        $configured_scopes = array( 'offline' );
        
        if ( isset($config['scope']) )
        {
            $config_scopes = array_map( 'trim', explode(',', $config['scope']) );

            foreach( $config_scopes as $scope )
            {
                if ( in_array( $scope, $this->_allowed_scopes ) )
                {
                    $configured_scopes[] = $scope;
                }
            }
            
            unset( $config['scope'] );
        }
        
        $this->setVariable( 'scope', implode(',', $configured_scopes) );
        
        parent::__construct($config);
    }
    
    /**
     * Получение ссылки на авторизацию
     *
     * @link http://vk.com/developers.php?o=-1&p=%C0%E2%F2%EE%F0%E8%E7%E0%F6%E8%FF%20%F1%E0%E9%F2%EE%E2
     */
    public function getAuthorizeUrl($params = array())
    {
        $params = array_merge(
            array(
                'client_id'     => $this->getVariable('client_id'),
                // здесь возможно нужен urlencode + уникальный ключ пользователя
                'redirect_uri'  => $this->getVariable('authorize_callback_uri'),
                'response_type' => ( $this->getVariable('logintype') == 'client' ) ? 'token' : 'code',
                'scope'         => $this->getVariable( 'scope' ),
        ), $params);
        
        return $this->getUri( $this->getVariable('authorize_uri'), $params);
    }
        
    /**
    * Авторизационный сервер vkontakte нам какбы отвечает
    * {"access_token":"533bacf01e11f55b536a565b57531ac114461ae8736d6506a3", "expires_in":43200, "user_id":6492}
    *
    * @link http://vk.com/developers.php?o=-1&p=%C0%E2%F2%EE%F0%E8%E7%E0%F6%E8%FF%20%F1%E0%E9%F2%EE%E2
    */
    protected function getSessionObject($access_token = NULL) 
    {
      $session = NULL;

      // Готовим данные для куки
      if (!empty($access_token) && isset($access_token['access_token'])) {
        $session['access_token'] = $access_token['access_token'];
        $session['expires'] = ( isset($access_token['expires_in']) && $access_token['expires_in'] ) ? time() + $access_token['expires_in'] : time() + $this->getVariable('expires_in', OAUTH2_DEFAULT_EXPIRES_IN);
        $session['refresh_token'] = isset($access_token['refresh_token']) ? $access_token['refresh_token'] : '';
        $session['user_id'] = isset($access_token['user_id']) ? $access_token['user_id'] : 0;

        $sig = self::generateSignature(
          $session,
          $this->getVariable('client_secret')
        );
        $session['sig'] = $sig;
      }

      return $session;
    }

    /**
     * У vkontakte вместо oauth_token имеем access_token
     *
     * @link http://vk.com/developers.php?o=-1&p=%C2%FB%EF%EE%EB%ED%E5%ED%E8%E5%20%E7%E0%EF%F0%EE%F1%EE%E2%20%EA%20API
     */
    protected function makeOAuth2Request($path, $method = 'GET', $params = array()) 
    {
      if ((!isset($params['access_token']) || empty($params['access_token'])) && $oauth_token = $this->getAccessToken()) 
      {
        $params['access_token'] = $oauth_token;
      }
      return $this->makeRequest($path, $method, $params);
    }
}