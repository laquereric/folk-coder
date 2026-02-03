# FolkCoder: User Personas & Use Cases

This document outlines the key user personas and their corresponding use cases for the FolkCoder platform, specifically focusing on the journey of a developer who has just completed the initial `swarmpod-core` setup.

## 1. The User Journey: From Localhost to Community

The journey begins when a developer successfully runs the `rails new --template` command from the `swarmpod-core` repository. They are directed from their local application to `folkcoder.com/next` to continue their learning. This context is critical: the user is not a generic visitor; they are an engaged developer who has just experienced the "magic" of SwarmPod and is primed to learn more.

## 2. Core User Personas

We have identified three primary personas representing the different types of developers who will follow this path.

### Persona 1: Curious Carlos (The Mid-Level Rails Developer)

| Attribute | Description |
| :--- | :--- |
| **Background** | 3-5 years of experience with Ruby on Rails. He is comfortable with the framework but is always looking for ways to improve his workflow and adopt modern practices. He has heard about "agentic programming" but has not yet tried it in a meaningful way. |
| **Motivation** | Intrigued by the promise of a one-command setup, Carlos is tired of the repetitive boilerplate configuration for every new project. He wants to see if SwarmPod can genuinely save him time and enforce a better, more scalable architecture from day one. |
| **Pain Points** | - The tedium of setting up Docker, managing secrets, and structuring a multi-repo application for every new project.<br>- The mental overhead of remembering and implementing architectural best practices consistently.<br>- The feeling that his project setups could be more professional and robust. |
| **Primary Goal** | To understand the "why" behind SwarmPod's architectural choices. He is looking for a structured curriculum that will take him from the initial "wow" moment to a deep understanding of how to build and deploy a production-ready, multi-repo Rails application. |

### Persona 2: Architect Amy (The Senior Developer / Tech Lead)

| Attribute | Description |
| :--- | :--- |
| **Background** | 10+ years of software development experience. As a tech lead, she is responsible for setting technical direction, mentoring her team, and ensuring the adoption of best practices. |
| **Motivation** | Amy is evaluating SwarmPod as a potential standard for her team. The promise of a "template-driven setup" that creates a consistent starting point for every team member is extremely appealing. She wants to see if this can reduce onboarding time for new hires and prevent architectural drift across projects. |
| **Pain Points** | - Inconsistent development environments across her team ("works on my machine" issues).<br>- Junior developers making architectural mistakes early in a project lifecycle, leading to costly refactoring later.<br>- The significant overhead of creating and maintaining internal project templates and documentation. |
| **Primary Goal** | To assess the depth, quality, and production-readiness of the SwarmPod curriculum. She is looking for advanced topics on deployment, security, customizability, and team-based workflows. She needs to be convinced that SwarmPod can handle real-world complexity before recommending it. |

### Persona 3: Bootcamp Brenda (The Aspiring Developer)

| Attribute | Description |
| :--- | :--- |
| **Background** | A recent graduate from a coding bootcamp, Brenda is highly motivated and eager to build a strong portfolio. She is proficient in the basics of Rails but lacks experience with professional-grade tools and workflows like Docker, multi-repo architecture, and secrets management. |
| **Motivation** | Brenda wants to differentiate herself in the job market. She knows that demonstrating knowledge of modern, professional development practices will make her a more attractive candidate. The simplicity of SwarmPod's setup gives her an accessible entry point into these advanced topics. |
| **Pain Points** | - Feeling overwhelmed by the sheer number of tools and concepts she is expected to know beyond basic Rails development.<br>- The "imposter syndrome" that comes from not knowing how "real" development teams work.<br>- Difficulty finding a clear, structured path to learn professional best practices. |
| **Primary Goal** | To complete the SwarmPod curriculum and build a polished, professional-looking project for her portfolio. She wants to gain the confidence and vocabulary to discuss modern architectural patterns in job interviews. |

## 3. Key Use Cases for FolkCoder

Based on these personas, we can define the primary use cases for the FolkCoder platform in the context of the SwarmPod curriculum.

| Use Case ID | Use Case | Primary Persona(s) | Description |
| :--- | :--- | :--- | :--- |
| **UC-01** | **Onboard and Start the Curriculum** | All | After being redirected from their local app, the user lands on `folkcoder.com/next`, understands the value proposition of the curriculum, and registers to begin their learning journey. |
| **UC-02** | **Follow a Structured Learning Path** | Brenda, Carlos | The user progresses through a series of modules that build upon the initial setup, covering topics like secrets management, Docker, GitHub workflows, and more. Their progress is tracked and saved. |
| **UC-03** | **Understand Architectural Principles** | Carlos, Amy | The user accesses content that explains the rationale behind SwarmPod's design choices (e.g., the benefits of multi-repo, the purpose of modular gems), linking theory to the practical application they have just created. |
| **UC-04** | **Evaluate Team-Based Workflows** | Amy | The user explores how SwarmPod's template-driven setup facilitates team collaboration, ensuring consistency and reducing friction when multiple developers work on the same project. |
| **UC-05** | **Build a Portfolio Project** | Brenda | The user leverages the SwarmPod template and the knowledge gained from the curriculum to build a unique application, which they can then add to their professional portfolio. |
| **UC-06** | **Connect with the Community** | All | The user discovers the broader FolkCoder platform, finds channels or forums related to SwarmPod, asks questions, and connects with other developers who are also going through the curriculum. |
| **UC-07** | **Discover Next Steps and Advanced Topics** | Carlos, Amy | After completing the core curriculum, the user is guided towards more advanced topics, such as customizing the SwarmPod template, contributing to the open-source project, or exploring other tools and frameworks featured on FolkCoder. |
