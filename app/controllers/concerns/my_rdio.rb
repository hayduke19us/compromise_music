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
    def self.new_playlist(rdio, name, description)
      rdio_playlist = rdio.call('createPlaylist',
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

    def self.delete_playlist(rdio, playlist)
      rdio.call('deletePlaylist', 'playlist' => playlist)
    end

    def self.all_playlist
       rdio.call('getPlaylists',
                   "extras" => "tracks")['result']['owned']
    end
  end
  
  class RdioTrack
    def self.add_track(rdio, playlist_key, track_key)
       rdio.call('addToPlaylist', 
                  'playlist' => playlist_key, 
                  'tracks' => track_key )
        
    end

      

    def self.track_attributes(track)
      Hash[name:          track['name'],
           key:           track['key'], 
           embedUrl:      track['embedUrl'], 
           ] 
    
    end

    def remove_track
    end

    def self.activity_stream(user)
       rdio.call('getHeavyRotation',
                   "user" => user, 
                   "type" => "artist", 
                   "friends" => "true")
    end

    def self.search_by_track(rdio, query)
      rdio.call('search',
                 'extras' => 'isrcs, 
                              iframeUrl,
                              isInCollection,
                              playCount,
                              bigIcon',
                  'query' => query, 
                  'types' => "Tracks")["result"]["results"]
             
    end
  end
end
