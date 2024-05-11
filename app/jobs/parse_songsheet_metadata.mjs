import { readFileSync } from "fs";
import { serializeError } from "serialize-error";
import ChordSheetJS from "chordsheetjs";

const stdin = readFileSync(0); // STDIN_FILENO = 0

try {
  const song = new ChordSheetJS.ChordProParser().parse(stdin.toString());
  process.stdout.write(JSON.stringify(song.metadata.metadata));
} catch (error) {
  process.stderr.write(JSON.stringify(serializeError(error)));
  process.exit(1);
}
