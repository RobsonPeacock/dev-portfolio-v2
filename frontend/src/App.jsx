import './index.css';
import Header from '../components/header.jsx';
import HeroSection from '../components/hero_section.jsx';
import SkillsSection from '../components/skills_section.jsx';
import CloudInfrastructureSection from '../components/cloud_infrastructure_section.jsx';
import GithubCalendar from '../components/github_calendar.jsx';
import WorkExperienceSection from '../components/work_experience_section.jsx';
import ProjectSection from '../components/project_section.jsx';
import EducationSection from '../components/education_section.jsx';
import ContactSection from '../components/contact_section.jsx';

function App() {

  return (
    <>
      <div className="min-h-screen bg-[#0B0F14] text-gray-100 font-mono relative overflow-hidden">
        <Header />
        <main>
          <HeroSection />
          <SkillsSection />
          <CloudInfrastructureSection />
          <GithubCalendar />
          <WorkExperienceSection />
          <ProjectSection />
          <EducationSection />
          <ContactSection />
        </main>
      </div>
    </>
  )
}

export default App
