import { useQuery } from "@tanstack/react-query";
import apiClient from "../src/api";

const fetchProjects = async () => {
  const response = await apiClient.get('/projects');
  return response.data;
}

function ProjectSection() {

  const { data, isLoading, isError, error } = useQuery({
    queryKey: ['projects'],
    queryFn: fetchProjects,
  });

  if (isLoading) return <div>Loading records from the database...</div>;
  if (isError) return <div>Error fetching data: {error.message}</div>;

  return (
    <>
      <section id="projects" className="max-w-7xl mx-auto px-6 py-16">
        <h3 className="text-3xl font-bold mb-8 text-green-400">Projects</h3>
        <div className="grid md:grid-cols-2 gap-6 items-stretch">
          {data.map((project, i) => (
            <div
              key={i}
              className="group relative overflow-hidden rounded-3xl border border-cyan-500/10 bg-[#111827]/70 backdrop-blur-md p-7 hover:border-cyan-400/20 transition-all duration-300 flex flex-col"
            >
              {/* Ambient Glow */}
              <div className="absolute top-0 right-0 w-52 h-52 bg-cyan-400/5 blur-3xl opacity-0 group-hover:opacity-100 transition duration-500"></div>

              <div className="relative z-10 flex flex-col h-full">
                <div>
                  <h4 className="text-2xl font-bold text-green-400 leading-tight mb-5">
                    {project.title}
                  </h4>

                  {project.tech_stack.map((tech) => (
                    <div className="inline-flex items-center gap-3 px-4 py-2 rounded-2xl border border-white/5 bg-[#0B0F14]/70 text-sm text-cyan-400 m-1">
                      { tech }
                    </div>
                  ))}

                  <p className="mt-7 text-gray-400 leading-7 text-sm">
                    {project.description}
                  </p>
                </div>
              </div>
            </div>
          ))}
        </div>
      </section>
    </>
  )
}

export default ProjectSection;