import Link from "next/link";

const MovieCard = ({ movie }) => {
  return (
    <Link href={`/movie/${movie.id}`} key={movie.id} legacyBehavior>
      <div className="flex flex-col cursor-pointer hover:scale-105 mr-6 bg-[#0B2039] w-64 overflow-hidden drop-shadow-md shadow-slate-400 p-3 rounded-2xl transition-all">
        <img
          className="w-full rounded-2xl"
          src={movie.banner}
          alt={movie.name}
        />

        <div className="pt-3 mb-1 flex-1">
          <div className="font-bold text-md mb-1 leading-tight">
            {movie.name}
          </div>
          <p className="text-xs text-[#C4C9CF]">
            {movie.description.slice(0, 50) + "..."}
          </p>
        </div>
        <div className="">
          <span className="inline-block bg-gray-200 rounded-full px-3 py-1 text-xs font-semibold text-gray-700 mr-2 mb-2">
            {movie.length} mins
          </span>
        </div>
      </div>
    </Link>
  );
};

export default MovieCard;
