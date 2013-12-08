module My_Rdio
  class RdioUser
    def self.verify_user(token, secret)  
      #create rdio object with current users info
      Rdio::SimpleRdio.new([Figaro.env.rdio_consumer_key, 
                            Figaro.env.rdio_consumer_secret],
                           [token, secret])
  
    end
  end

  class RdioPlaylist 
    def self.verified(rdio)
      @rdio = rdio
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
  end
  
  class RdioTrack
   
    def self.verified(rdio)
      @rdio = rdio
    end
  
   def self.add_track(playlist_key, track_key)
       @rdio.call('addToPlaylist', 
                  'playlist' => playlist_key, 
                  'tracks' => track_key )
        
    end

      

    def self.track_attributes(track)
      Hash[name:          track['name'],
           key:           track['key'], 
           embedUrl:      track['embedUrl'], 
           artist:        track['artist'] 
           album:         track['album']
          ] 
    
    end

    def self.remove_track(playlist_key, index, track_key)
      @rdio.call('removeFromPlaylist',
                 'playlist'  => playlist_key,
                 'index' => index.to_s,
                 'count' => "1",
                 'tracks' => track_key)
    end

    def self.activity_stream(user)
       @rdio.call('getHeavyRotation',
                   "user" => user, 
                   "type" => "artist", 
                   "friends" => "true")
    end

    def self.search_by_track(type, query)
      @rdio.call('search',
                 'extras' => 'isrcs, 
                              iframeUrl,
                              isInCollection,
                              playCount,
                              bigIcon',
                  'query' => query, 
                  'types' => type)["result"]["results"]
             
    end

    def self.albums_for_artist(artist_key, featured='false')
      @rdio.call('getAlbumsForArtist',
                 'extras' => 'iframeUrl,
                              label,
                              bigIcon',
                 'artist' => artist_key,
                 'featured' => featured)['result']
    end

    def self.get(object_key)
      @rdio.call('get', 
                 'keys' => object_key,
                 'extras' => 'iframeUrl')['result']
    
    end
  end

end
