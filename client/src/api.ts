export type Home = {
  name: string;
  href: string;
  format: "item" | "card";
  items: (Songsheet | Setlist | Artist | Album)[];
}[];

export type Discover = {
  setlists: Setlist[];
};

export type Genre = {
  id: string;
  type: "Genre";
  name: string;
  created_at: string;
  updated_at: string;
  thumbnail: string;
  url: string;
};

export type Artist = {
  id: string;
  uid: string;
  type: "Artist";
  name: string;
  created_at: string;
  updated_at: string;
  thumbnail: string;
  url: string;
};

export type ArtistFull = Artist & {
  biography: string;
  style: string;
  banner: string;
  genre: Genre;
};

export type Album = {
  id: string;
  type: "Album";
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
  artist: Artist;
  genre: Genre;
};

export type AlbumFull = Album & {
  description: string;
  tracks: Track[];
};

export type Track = {
  id: string;
  type: "Track";
  title: string;
  number: number;
  duration: number;
  created_at: string;
  updated_at: string;
  songsheets_count: number;
  has_songsheet: boolean;
  url: string;
  artist: Artist;
  album: Album;
};

export type TrackFull = Track & {
  songsheets: Songsheet[];
};

export type Songsheet = {
  id: string;
  type: "Songsheet";
  title: string;
  subtitle: string;
  track?: TrackFull;
  metadata: {
    key?: string;
    capo?: string;
  };
  duration?: number;
  created_at: string;
  updated_at: string;
  url: string;
};

export type SongsheetFull = Songsheet & {
  source: string;
  imported_from: string;
  media: string[];
  artists: Artist[];
  copyright: {
    notice: string;
    url: string;
    script_url: string;
    pixel_url: string;
  };
};

export type Setlist = {
  id: string;
  type: "Setlist";
  uid: string;
  title: string;
  created_at: string;
  updated_at: string;
  description: string;
  user: User;
  thumbnails: string[];
  url: string;
};

export type User = {
  id: string;
  type: "User";
  name: string;
  email?: string;
};

export type Errors = Record<string, string[]>;

export type SignUp = {
  user: {
    name: string;
    email: string;
    password: string;
  };
};
