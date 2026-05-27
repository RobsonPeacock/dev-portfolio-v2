import { FaGithub, FaLinkedin, FaCode } from 'react-icons/fa';

function Footer() {
  return (
    <>
      <footer className="border-t border-cyan-500/10 bg-[#111827]/80 backdrop-blur-sm mt-12">
        <div className="max-w-7xl mx-auto px-6 py-8 flex flex-col items-center justify-center gap-4 text-sm text-gray-400 text-center">
          <div>
            <p className="text-cyan-400 font-semibold">Robson Peacock</p>
            <p className="mt-3">Backend Engineer | Infrastructure as Code | Cloud Systems</p>
            <p className="mt-3">London, UK</p>
          </div>

          <div className="flex items-center justify-center gap-5 text-cyan-400">
            <a
              href="https://github.com/robsonpeacock"
              target="_blank"
              rel="noopener noreferrer"
              className="hover:text-green-400 transition"
              aria-label="GitHub"
            >
              <FaGithub className="w-5 h-5" />
            </a>

            <a
              href="https://linkedin.com/in/robson-peacock"
              target="_blank"
              rel="noopener noreferrer"
              className="hover:text-green-400 transition"
              aria-label="LinkedIn"
            >
              <FaLinkedin className="w-5 h-5" />
            </a>

            <a
              href="https://www.codewars.com/users/Robson_Peacock"
              target="_blank"
              rel="noopener noreferrer"
              className="hover:text-green-400 transition"
              aria-label="CodeWars"
            >
              <FaCode className="w-5 h-5" />
            </a>
          </div>

          <button
            onClick={() => window.scrollTo({ top: 0, behavior: 'smooth' })}
            className="mt-2 px-4 py-2 rounded-xl border border-cyan-400/20 bg-[#0B0F14] hover:border-green-400 hover:text-cyan-300 transition text-cyan-400 text-sm"
          >
            ↑ Top
          </button>

          <p className="text-xs text-gray-500">
            © 2026 robsonpeacock.dev
          </p>
        </div>
      </footer>
    </>
  )
}

export default Footer;