import { useState } from 'react';

function Header() {
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

  return (
    <>
      <header className="border-b border-cyan-500/20 bg-[#111827] sticky top-0 z-50">
        <div className="max-w-7xl mx-auto px-6 py-4 flex justify-between items-center">
          <h1 className="text-xl font-bold text-cyan-400">$ robsonpeacock.dev</h1>
          <nav className="hidden md:flex space-x-6 text-sm">
            <a href="#projects" className="hover:text-green-400">Projects</a>
            <a href="#skills" className="hover:text-green-400">Skills</a>
            <a href="#contact" className="hover:text-green-400">Contact</a>
          </nav>

          <button
            onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
            className="md:hidden text-cyan-400 hover:text-green-400 transition"
            aria-label="Toggle menu"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 24 24"
              strokeWidth={1.8}
              stroke="currentColor"
              className="w-7 h-7"
            >
              {mobileMenuOpen ? (
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  d="M6 18L18 6M6 6l12 12"
                />
              ) : (
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  d="M3.75 6.75h16.5m-16.5 5.25h16.5m-16.5 5.25h16.5"
                />
              )}
            </svg>
          </button>

          {mobileMenuOpen && (
            <div className="absolute top-full right-6 mt-3 w-48 bg-[#111827]/95 backdrop-blur-md border border-cyan-500/10 rounded-2xl shadow-[0_0_30px_rgba(0,191,255,0.08)] overflow-hidden md:hidden">
              <a href="#projects" className="block px-5 py-4 text-sm hover:bg-cyan-400/10 hover:text-cyan-300 transition">
                Projects
              </a>
              <a href="#skills" className="block px-5 py-4 text-sm hover:bg-cyan-400/10 hover:text-cyan-300 transition">
                Skills
              </a>
              <a href="#contact" className="block px-5 py-4 text-sm hover:bg-cyan-400/10 hover:text-cyan-300 transition">
                Contact
              </a>
            </div>
          )}
        </div>
      </header>
    </>
  )
}

export default Header;