module My_Rdio
  def self.verify_user(token, secret)
    #create a rdio object with current users info
    @rdio = Rdio::SimpleRdio.new([Figaro.env.rdio_consumer_key, 
                                  Figaro.env.rdio_consumer_secret],
                                 [token, secret])
  
  end

  def self.new_playlist(name, description)
    #creating a new playlist with user "['result'] is a recursive action "
    rdio_playlist = @rdio.call('createPlaylist',
                              'name' => name,
                              'description' => description,
                              'tracks' => 't35335083', 
                              'collaborationMode' => '1')['result']

    @name = name
    @description = description
    @embedUrl = rdio_playlist['embedUrl']
    @key = rdio_playlist['key']
  end
  
  def self.playlist_attributes(user_id)
    Hash[name: @name, 
         description: @description,
         embedUrl: @embedUrl,
         key: @key,
         user_id: user_id]
  end

  def self.delete_playlist(playlist)
    @rdio.call('deletePlaylist', 'playlist' => playlist)
  end

  def self.all_playlist
     @rdio.call('getPlaylists',
                 "extras" => "tracks")['result']['owned']
  end
  
  def self.add_track(playlist_key, track_key)
     @rdio.call('addToPlaylist', 
                'playlist' => playlist_key, 
                'tracks' => track_key )
      
     
  end

  def self.track_attributes(track, playlist, playlist_id, index)
    Hash[name:          track['name'],
         key:           track['key'], 
         embedUrl:      track['embedUrl'], 
         playlist_key:  playlist,
         playlist_id:   playlist_id,
         index:         index] 
  
  end

  def remove_track
  end

  def current_user
  end

  def self.activity_stream(user)
     @rdio.call('getHeavyRotation',
                 "user" => user, 
                 "type" => "artist", 
                 "friends" => "true")
  end

  def self.search_by_track(query)
    @rdio.call('search',
               'extras' => 'isrcs, 
                            iframeUrl,
                            isInCollection,
                            playCount,
                            bigIcon',
                'query' => query, 
                'types' => "Tracks")["result"]["results"]
           
  end
  def track_search_result(result)
    result.each do |r|
    Hash.new[key: r['key'],
             name: r['name'],
             artist: r['artist'],
             album: r['album'],
             album_key: r['albumKey'],
             album_url: r['artistKey'],
             artist_url: r['artistUrl'],
             duration: r['duration'],
             base_icon: r['baseIcon'],
             embed_url: r['embedUrl'],
             iframe_url: r['iframeUrl'], 
             play_count: r['playCount'],
             big_icon: r['bigIcon']]
     end
  end
end
