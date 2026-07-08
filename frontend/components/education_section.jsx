import { useQuery } from "@tanstack/react-query";
import apiClient from "../src/api";

const fetchEducations = async () => {
  const response = await apiClient.get('/educations');
  return response.data;
}

function EducationSection() {

  const { data, isLoading, isError, error } = useQuery({
    queryKey: ['educations'],
    queryFn: fetchEducations,
  });

  if (isLoading) return <div>Loading records from the database...</div>;
  if (isError) return <div>Error fetching data: {error.message}</div>;

  return (
    <>
      <section className="max-w-6xl mx-auto px-6 py-20 overflow-hidden">
        <div className="flex items-center justify-between mb-10 flex-wrap gap-4">
          <div>
            <p className="text-sm uppercase tracking-[0.35em] text-cyan-400/60 mb-3">
              Learning Path
            </p>

            <h3 className="text-4xl font-bold text-white">
              Education & Certifications
            </h3>
          </div>
        </div>

        <div className="grid md:grid-cols-3 gap-6">
          {data.map((item, i) => (
            <div
              key={i}
              className={`group relative overflow-hidden rounded-3xl border backdrop-blur-md p-6 min-h-55 transition-all duration-300 hover:-translate-y-1 border-cyan-400/20 bg-cyan-500/3`}
            >
              <div
                className={`absolute top-0 right-0 w-32 h-32 blur-3xl opacity-10 transition-opacity duration-300 group-hover:opacity-20 bg-green-400`}
              ></div>

              <div className="relative z-10 flex flex-col h-full justify-between">
                <div>
                  <div className="flex items-center justify-between mb-5">
                    <span
                      className={`text-xs uppercase tracking-[0.25em]`}
                    >
                      {item.type}
                    </span>

                    <span className="text-xs text-gray-500">
                      {item.period}
                    </span>
                  </div>

                  <h4 className="text-2xl font-bold text-white leading-tight mb-3">
                    {item.title}
                  </h4>

                  <p className="text-gray-400 text-sm leading-7">
                    {item.institution}
                  </p>
                </div>

                <div className="mt-8 flex items-center gap-3">
                  <div
                    className={`w-2.5 h-2.5 rounded-full bg-cyan-400`}
                  ></div>

                  <div className="h-px flex-1 bg-white/10"></div>

                    {item.certification_url && (
                      <a
                        href={item.certification_url}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="group inline-flex items-center gap-2 text-sm text-gray-400 hover:text-cyan-300 transition"
                      >
                        View Credential
                  
                        <svg
                          xmlns="http://www.w3.org/2000/svg"
                          viewBox="0 0 24 24"
                          fill="none"
                          stroke="currentColor"
                          strokeWidth="1.8"
                          className="w-4 h-4 transition-transform group-hover:translate-x-0.5 group-hover:-translate-y-0.5"
                        >
                          <path
                            strokeLinecap="round"
                            strokeLinejoin="round"
                            d="M13.5 6H18m0 0v4.5M18 6l-7.5 7.5"
                          />
                          <path
                            strokeLinecap="round"
                            strokeLinejoin="round"
                            d="M15 13.5V18a1.5 1.5 0 01-1.5 1.5H6A1.5 1.5 0 014.5 18V10.5A1.5 1.5 0 016 9h4.5"
                          />
                        </svg>
                      </a>
                    )}
                </div>
              </div>
            </div>
          ))}
        </div>
      </section>
    </>
  )
}

export default EducationSection;