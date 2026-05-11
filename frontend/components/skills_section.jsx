function SkillsSection() {
  return (
    <>
      <section id="skills" className="max-w-7xl mx-auto px-6 py-16">
        <h3 className="text-3xl font-bold mb-8 text-green-400">Tech Stack</h3>
        <div className="flex flex-wrap gap-4">
          {['Docker','Kubernetes','Terraform','AWS','Jenkins','Ansible','Linux','GitHub Actions'].map(skill => (
            <span key={skill} className="px-4 py-2 rounded-full bg-[#111827] border border-cyan-500/20 hover:border-green-400">
              {skill}
            </span>
          ))}
        </div>
      </section>
    </>
  )
}

export default SkillsSection;