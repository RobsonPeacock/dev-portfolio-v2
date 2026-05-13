function CloudInfrastructureSection() {
  return (
    <>
      <section className="max-w-7xl mx-auto px-6 py-24">
        <div className="text-center mb-16">
          <h3 className="text-4xl font-bold text-white mb-4">
            Cloud Infrastructure
          </h3>

          <p className="text-gray-400 max-w-2xl mx-auto leading-7">
            A suite of services and tools I leverage to architect scalable 
            backend systems, automate deployments, and manage distributed 
            infrastructure with full observability.
          </p>
        </div>

        <div className="relative max-w-6xl mx-auto">
          <div className="absolute inset-0 flex items-center justify-center pointer-events-none opacity-30">
            <div className="w-[70%] h-px bg-linear-to-r from-transparent via-cyan-400 to-transparent"></div>
          </div>

          <div className="grid lg:grid-cols-3 gap-8 relative z-10">
            {[
              {
                title: 'Compute & Workload',
                icon: '◉',
                color: 'text-cyan-400',
                border: 'border-cyan-400/20',
                glow: 'shadow-[0_0_40px_rgba(34,211,238,0.08)]',
                services: ['EC2', 'Lambda', 'ECS', 'EKS']
              },
              {
                title: 'Cloud Foundations',
                icon: '◎',
                color: 'text-green-400',
                border: 'border-green-400/20',
                glow: 'shadow-[0_0_40px_rgba(74,222,128,0.08)]',
                services: ['S3', 'RDS', 'VPC', 'Route 53', 'CloudFront']
              },
              {
                title: 'Automation & CI/CD',
                icon: '◈',
                color: 'text-purple-400',
                border: 'border-purple-400/20',
                glow: 'shadow-[0_0_40px_rgba(192,132,252,0.08)]',
                services: ['Terraform', 'CloudWatch', 'CodePipeline', 'IAM', 'SNS/SQS']
              }
            ].map(layer => (
              <div
                key={layer.title}
                className={`relative overflow-hidden rounded-3xl bg-[#111827]/70 backdrop-blur-md border ${layer.border} ${layer.glow} p-8 transition-all duration-300 hover:-translate-y-2`}
              >
                <div className="absolute top-0 right-0 w-40 h-40 bg-white/5 blur-3xl rounded-full"></div>

                <div className="relative z-10">
                  <div className="flex items-center gap-4 mb-8">
                    <div className={`text-3xl ${layer.color}`}>
                      {layer.icon}
                    </div>

                    <div>
                      <p className="text-xs uppercase tracking-[0.25em] text-gray-500 mb-1">
                        Infrastructure Domain
                      </p>

                      <h4 className={`text-2xl font-semibold ${layer.color}`}>
                        {layer.title}
                      </h4>
                    </div>
                  </div>

                  <div className="space-y-4">
                    {layer.services.map(service => (
                      <div
                        key={service}
                        className="flex items-center justify-between rounded-xl border border-white/5 bg-[#0B0F14]/70 px-4 py-3 hover:border-cyan-400/20 transition"
                      >
                        <span className="text-gray-300 text-sm">
                          {service}
                        </span>

                        <div className="w-2.5 h-2.5 rounded-full bg-green-400 shadow-[0_0_12px_rgba(74,222,128,0.8)]"></div>
                      </div>
                    ))}
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>
    </>
  )
}

export default CloudInfrastructureSection;