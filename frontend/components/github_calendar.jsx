import { GitHubCalendar } from 'react-github-calendar';

function GithubCalendar() {
  return (
    <section className="max-w-7xl mx-auto px-6 py-16">
      <h3 className="text-3xl font-bold mb-8 text-cyan-400">GitHub Activity</h3>

      <div className="bg-[#111827] rounded-2xl p-5 border border-cyan-500/5 overflow-hidden relative max-w-5xl mx-auto">
        <GitHubCalendar
          username="robsonpeacock"
          blockSize={14}
          blockMargin={5}
          fontSize={14}
          colorScheme="dark"
          theme={{
            dark: ['#161B22', '#0E4429', '#006D32', '#26A641', '#39D353']
          }}
        />
      </div>
    </section>
  )
}

export default GithubCalendar;