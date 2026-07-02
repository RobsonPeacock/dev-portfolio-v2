import { useState } from 'react';
import { useQuery } from "@tanstack/react-query";
import apiClient from "../src/api";

const fetchWorkExperience = async () => {
  const response = await apiClient.get('/work_experiences');
  return response.data;
}

function WorkExperienceSection() {

  const { data, isLoading, isError, error } = useQuery({
    queryKey: ['work_experiences'],
    queryFn: fetchWorkExperience,
  });

  const [openJob, setOpenJob] = useState(null);
  const [showAllJobs, setShowAllJobs] = useState(false);

  if (isLoading) return <div>Loading records from the database...</div>;
  if (isError) return <div>Error fetching data: {error.message}</div>;

  return (
    <>
      <section className="max-w-7xl mx-auto px-6 py-20">
        <h3 className="text-3xl font-bold mb-12 text-green-400 text-center">Work Experience</h3>

        <div className="relative max-w-7xl mx-auto">
          <div className="absolute left-1/2 top-0 h-full w-px bg-linear-to-b from-cyan-400 via-green-400 to-transparent transform -translate-x-1/2"></div>

          {data.slice(0, showAllJobs ? undefined : 3).map((job, i) => (
            <div
              key={i}
              className={`relative mb-16 flex ${i % 2 === 0 ? 'justify-start' : 'justify-end'}`}
            >
              <div className="absolute left-1/2 top-6 w-5 h-5 rounded-full bg-cyan-400 border-4 border-[#0B0F14] shadow-[0_0_20px_rgba(0,191,255,0.8)] transform -translate-x-1/2"></div>

              <div className="w-full md:w-[45%] bg-[#111827]/90 backdrop-blur-sm rounded-2xl border border-cyan-500/10 hover:border-green-400 transition shadow-[0_0_25px_rgba(0,255,156,0.05)] overflow-hidden">
                <button
                  onClick={() => setOpenJob(openJob === i ? null : i)}
                  className="w-full text-left p-6"
                >
                <div className="flex items-center justify-between">
                    <div className="flex flex-col gap-2">
                  <span className="text-sm text-green-400">{job.period}</span>
                  <h4 className="text-xl font-semibold text-cyan-400">{job.role}</h4>
                  <p className="text-gray-400">{job.company}</p>
                    </div>

                    <span className="text-cyan-400 text-2xl">
                      {openJob === i ? '−' : '+'}
                    </span>
                  </div>
                </button>

                {openJob === i && (
                  <div className="px-6 pb-6 border-t border-cyan-500/10 pt-4">
                    <p className="text-gray-400 text-sm leading-6">
                      {job.description.split(".").slice(0, -1).map((description) => (
                        <ul>
                          <li class="p-2">- { description }</li>
                        </ul>
                      ))}
                    </p>
                  </div>
                )}
              </div>
            </div>
          ))}
        </div>

        <div className="flex justify-center mt-12">
          <button
            onClick={() => setShowAllJobs(!showAllJobs)}
            className="px-6 py-3 rounded-xl border border-cyan-400/20 bg-[#111827] hover:border-green-400 text-cyan-400 transition"
          >
            {showAllJobs ? 'Collapse Timeline' : 'Expand Timeline'}
          </button>
        </div>
      </section>
    </>
  )
}

export default WorkExperienceSection;