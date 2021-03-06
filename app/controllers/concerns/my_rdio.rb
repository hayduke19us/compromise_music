module My_Rdio

  class RdioUser
    def self.verify_user(token, secret)
      #create rdio object with current users info
      Rdio::SimpleRdio.new(["vc76wjg3xyyqawc7m7dttjmq",
                            "NxMYesjNWW"],
                           [token, secret])

    end


    def self.verified(rdio)
      @rdio = rdio
    end

    def self.heavy_rotation(key)
      @rdio.call('getHeavyRotation',
                 'user' => key,
                 'friends' => 'true',
                 'count' => '48')['result']

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
      RdioTrack.remove_track(@key, '0', 't35335083', 1)
    end

    def self.delete_playlist(key)
      @rdio.call('deletePlaylist', 'key' => key)
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

    def self.playlist_order playlist_key, tracks
      @rdio.call('setPlaylistOrder',
                 'playlist' => playlist_key,
                 'tracks' => tracks) 
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
           artist:        track['artist'],
           album:         track['album'],
           album_key:     track['albumKey']
         ]

    end

    def self.remove_track(playlist_key, index, track_key, count)
      @rdio.call('removeFromPlaylist',
                 'playlist'  => playlist_key,
                 'index' => index.to_s,
                 'count' => count.to_s,
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

    def self.get_tracks_for_artist(artist_key, query=nil)
     @rdio.call('getTracksForArtist',
               'artist' => artist_key,
               'sort' => 'releaseDate',
               'query' => query)['result']
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

  class RdioSearch
    attr_accessor :search_type, :query, :artist_key, :list
    def initialize(args)
      @search_type = args[:search_type]
      @query = args.fetch(:query, nil)
      @artist_key = args.fetch(:artist_key, nil)
      @list = args.fetch(:list, nil)
    end

    def simple
      search_result = RdioTrack.search_by_track search_type, query
    end

    def artist_tracks(track_name)
      tracks = RdioTrack.get_tracks_for_artist artist_key, track_name
    end

    def artist_albums
      search_result = RdioTrack.albums_for_artist artist_key
    end

    def album_tracks
      if list.class == Array
        album_tracks = RdioTrack.get list.join(",")
      else
        album = RdioTrack.get list
        album = album.flatten
        album_tracks = RdioTrack.get album[1]['trackKeys'].join(",")
      end
    end
  end
end
