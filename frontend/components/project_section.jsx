function ProjectSection() {

  return (
    <>
      <section id="projects" className="max-w-7xl mx-auto px-6 py-16">
        <h3 className="text-3xl font-bold mb-8 text-green-400">Projects</h3>
        <div className="grid md:grid-cols-2 gap-6 items-stretch">
          {[
            {
              title: 'Realtime Analytics Platform',
              architecture:
                'Frontend → API Gateway → Node API → PostgreSQL',
              details:
                'Built a scalable analytics platform with realtime websocket updates, background workers, and containerized deployment pipelines.',
              tags: ['Docker', 'AWS', 'PostgreSQL', 'WebSockets', 'Node.js'],
            },
            {
              title: 'Cloud Deployment Dashboard',
              architecture:
                'React → Rails API → Redis → Kubernetes',
              details:
                'Created an internal deployment dashboard with monitoring integrations, role-based access, and automated rollout tooling.',
              tags: ['Kubernetes', 'Terraform', 'Rails', 'Redis'],
            },
            {
              title: 'Distributed Queue Processing System',
              architecture:
                'API → RabbitMQ → Worker Services → PostgreSQL',
              details:
                'Designed a distributed job processing architecture capable of handling high throughput asynchronous workloads.',
              tags: ['RabbitMQ', 'Docker', 'AWS', 'Workers'],
            },
            {
              title: 'Observability & Monitoring Platform',
              architecture:
                'Prometheus → Grafana → Alertmanager → Slack',
              details:
                'Built centralized monitoring dashboards and alert pipelines for production services with infrastructure visibility.',
              tags: ['Prometheus', 'Grafana', 'Monitoring', 'Kubernetes'],
            },
          ].map((project, i) => (
            <div
              key={i}
              className="group relative overflow-hidden rounded-3xl border border-cyan-500/10 bg-[#111827]/70 backdrop-blur-md p-7 hover:border-cyan-400/20 transition-all duration-300 flex flex-col"
            >
              {/* Ambient Glow */}
              <div className="absolute top-0 right-0 w-52 h-52 bg-cyan-400/5 blur-3xl opacity-0 group-hover:opacity-100 transition duration-500"></div>

              <div className="relative z-10 flex flex-col h-full">
                <div>
                  <h4 className="text-2xl font-bold text-white leading-tight mb-5">
                    {project.title}
                  </h4>

                  <div className="inline-flex items-center gap-3 px-4 py-2 rounded-2xl border border-white/5 bg-[#0B0F14]/70 text-sm text-gray-400">
                    <div className="w-2 h-2 rounded-full bg-green-400 shadow-[0_0_10px_rgba(74,222,128,0.8)]"></div>

                    {project.architecture}
                  </div>

                  <p className="mt-7 text-gray-400 leading-7 text-sm">
                    {project.details}
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