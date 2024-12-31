// TODO:
// - generate these from API serializers
// - Separate partial/full types

export type Genre = {
  id: string;
  type: 'Genre';
  name: string;
  created_at: string;
  updated_at: string;
  thumbnail: string;
  url: string;
}

export type Artist = {
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

export type Album = {
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

export type Track = {
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

export type Songsheet = {
  id: string;
  type: 'Songsheet'
  title: string;
  subtitle: string;
  track?: Track;
  metadata: {
    key?: string;
    capo?: string;
  };
}

export type Setlist = {
  id: string;
  type: 'Setlist';
  uid: string;
  title: string;
  created_at: string;
  updated_at: string;
  description: string,
  user: User
  thumbnails: string[]
  url: string
}

export type User = {
  id: string
  type: 'User'
  name: string
  email?: string
}
