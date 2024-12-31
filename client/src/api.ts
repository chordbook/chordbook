// TODO:
// - generate these from API serializers
// - Separate partial/full types

export interface Genre {
  id: string;
  type: 'Genre';
  name: string;
  created_at: string;
  updated_at: string;
  thumbnail: string;
  url: string;
}

export interface Artist {
  id: string;
  uid: string;
  type: 'Artist';
  name: string;
  created_at: string;
  updated_at: string;
  thumbnail: string;
  url: string

  // full
  biography: string;
  style: string;
  banner: string;
  genre: Genre;
}

export interface Album {
  id: string;
  type: 'Album';
  title: string;
  released: number;
  created_at: string;
  updated_at: string;
  style: string;
  cover: {
    small: string;
    medium: string;
    large: string;
  };
  url: string;

  // full
  artist: Artist;
  genre: Genre;
}

export interface Track {
  id: string;
  type: 'Track';
  title: string;
  number: number;
  duration: number;
  created_at: string;
  updated_at: string;
  songsheets_count: number;
  has_songsheet: boolean;
  url: string;

  // full
  artist: Artist;
  album: Album;
}

export interface Songsheet {
  id: string;
  title: string;
  subtitle: string;
  track?: Track;
  metadata: {
    key?: string;
    capo?: string;
  };
}
