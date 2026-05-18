function HeroSection() {
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
Backend Engineer | Platform Builder | Cloud Enthusiast

$ skills --list
Node.js Python APIs Databases Cloud CI/CD Linux`}
            </pre>
          </div>

          <div className="flex flex-col items-center">
            <div className="mb-6 relative">
              <img
                src="https://placeholdit.com/180x180"
                alt="Profile placeholder"
                className="w-44 h-44 rounded-2xl object-cover border-2 border-cyan-400 shadow-[0_0_30px_rgba(0,191,255,0.25)]"
              />
              <div className="absolute -inset-1 rounded-2xl border border-green-400/30 blur-sm"></div>
            </div>
            <h2 className="text-5xl font-bold leading-tight">
              Building <span className="text-cyan-400">Scalable Backend Systems</span>
            </h2>
            <p className="mt-6 text-gray-400 text-lg">
              I build APIs, architect scalable platforms, automate deployments, and optimize production systems.
            </p>
            <div className="flex items-center gap-2 text-sm text-cyan-300 border border-cyan-500/20 bg-[#111827]/70 px-4 py-2 rounded-full backdrop-blur-sm my-3">
              <span>📍 London, UK</span>
            </div>
          </div>
        </section>
    </>
  )
}

export default HeroSection;