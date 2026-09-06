import { useQuery } from "@tanstack/react-query";
import apiClient from "../src/api";

const fetchAbout = async () => {
  const response = await apiClient.get('/about');
  return response.data;
}

function HeroSection() {

  const { data, isLoading, isError, error } = useQuery({
    queryKey: ['about'],
    queryFn: fetchAbout,
  });

  if (isLoading) return (
    <>
      <section className="max-w-7xl mx-auto px-6 py-24 grid md:grid-cols-2 gap-12 items-center">
        <div className="bg-black rounded-2xl shadow-2xl border border-green-500/20 p-6 h-72.5 animate-pulse">
          <div className="flex space-x-2 mb-6">
            <div className="w-3 h-3 rounded-full bg-gray-800"></div>
            <div className="w-3 h-3 rounded-full bg-gray-800"></div>
            <div className="w-3 h-3 rounded-full bg-gray-800"></div>
          </div>
          <div className="space-y-4">
            <div className="h-4 w-20 bg-gray-800 rounded"></div>
            <div className="h-4 w-36 bg-gray-800/60 rounded"></div>
            <div className="h-4 w-16 bg-gray-800 rounded mt-6"></div>
            <div className="h-4 w-80 bg-gray-800/60 rounded"></div>
            <div className="h-4 w-28 bg-gray-800 rounded mt-6"></div>
            <div className="h-4 w-96 bg-gray-800/60 rounded"></div>
          </div>
        </div>

        <div className="flex flex-col items-center w-full">
          <div className="mb-6 relative animate-pulse">
            <div className="w-44 h-44 rounded-2xl bg-gray-800 border-2 border-gray-700"></div>
          </div>

          <div className="w-full flex flex-col items-center animate-pulse">
            <div className="h-12 w-4/5 bg-gray-800 rounded-xl mb-3"></div>
            <div className="h-12 w-3/5 bg-gray-800 rounded-xl"></div>
          </div>

          <div className="mt-6 w-full max-w-md space-y-3 animate-pulse">
            <div className="h-4 w-full bg-gray-800 rounded"></div>
            <div className="h-4 w-11/12 bg-gray-800 rounded mx-auto"></div>
            <div className="h-4 w-4/5 bg-gray-800 rounded mx-auto"></div>
          </div>

          <div className="mt-6 h-9 w-32 bg-gray-800/70 border border-gray-700/50 rounded-full animate-pulse"></div>
        </div>
      </section>
    </>
  );
  if (isError) return <div>Error fetching data: {error.message}</div>;

  return (
    <>
        <section className="max-w-7xl mx-auto px-6 py-24 grid md:grid-cols-2 gap-12 items-center">
          <div className="bg-black rounded-2xl shadow-2xl border border-green-500/20 p-6">
            <div className="flex space-x-2 mb-4">
              <span className="w-3 h-3 rounded-full bg-red-500"></span>
              <span className="w-3 h-3 rounded-full bg-yellow-500"></span>
              <span className="w-3 h-3 rounded-full bg-green-500"></span>
            </div>
            <pre className="text-green-400 text-sm leading-7 whitespace-pre-wrap">
{`$ whoami
Robson Peacock

$ role
Backend Engineer | Infrastructure as Code | Cloud Systems

$ skills --list
Ruby on Rails AWS Terraform GitHub Actions SQL NodeJS`}
            </pre>
          </div>

          <div className="flex flex-col items-center">
            <div className="mb-6 relative">
              <img
                src={data.profile_image_url}
                alt="Profile placeholder"
                className="w-44 h-44 rounded-2xl object-cover border-2 border-cyan-400 shadow-[0_0_30px_rgba(0,191,255,0.25)]"
              />
              <div className="absolute -inset-1 rounded-2xl border border-green-400/30 blur-sm"></div>
            </div>
            <h2 className="text-5xl font-bold leading-tight">
              Building <span className="text-cyan-400">Scalable Backend Systems</span>
            </h2>
            <p className="mt-6 text-gray-400 text-lg">
              {data.bio}
            </p>
            <div className="flex items-center gap-2 text-sm text-cyan-300 border border-cyan-500/20 bg-[#111827]/70 px-4 py-2 rounded-full backdrop-blur-sm my-3">
              <span>{data.location}</span>
            </div>
          </div>
        </section>
    </>
  )
}

export default HeroSection;