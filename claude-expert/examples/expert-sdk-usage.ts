#!/usr/bin/env node
/**
 * Claude Expert System - Advanced SDK Usage Example
 * This demonstrates how to programmatically use Claude Code with the expert system
 */

import { query, ClaudeCodeOptions } from "@anthropic-ai/claude-code";
import * as fs from 'fs/promises';
import * as path from 'path';

interface ExpertAnalysisResult {
  summary: string;
  findings: {
    architecture: string[];
    security: string[];
    performance: string[];
    codeQuality: string[];
  };
  recommendations: {
    priority: 'critical' | 'high' | 'medium' | 'low';
    description: string;
    effort: string;
  }[];
}

/**
 * Advanced expert analysis using multi-agent orchestration
 */
async function performExpertAnalysis(projectPath: string): Promise<ExpertAnalysisResult> {
  const options: ClaudeCodeOptions = {
    maxTurns: 20,
    workingDirectory: projectPath,
    systemPrompt: await fs.readFile(
      path.join(process.env.HOME!, '.dotfiles/claude-expert/CLAUDE.md'), 
      'utf-8'
    ),
    abortController: new AbortController()
  };

  const analysisPrompt = `
<expert_analysis_request>
<thinking>
I need to perform a comprehensive expert-level analysis using multiple specialized agents.
This requires parallel execution for efficiency and deep analysis of various aspects.
</thinking>

Please perform a comprehensive expert analysis of this codebase using the multi-agent approach.

Deploy these agents in parallel:
1. Architecture Analyst - Review overall design and patterns
2. Security Auditor - Identify vulnerabilities and risks  
3. Performance Engineer - Find bottlenecks and optimization opportunities
4. Code Quality Inspector - Check standards and best practices

<output_format>
Provide results in this JSON structure:
{
  "summary": "Executive summary of findings",
  "findings": {
    "architecture": ["finding1", "finding2"],
    "security": ["finding1", "finding2"],
    "performance": ["finding1", "finding2"],
    "codeQuality": ["finding1", "finding2"]
  },
  "recommendations": [
    {
      "priority": "critical|high|medium|low",
      "description": "What to do",
      "effort": "Estimated effort"
    }
  ]
}
</output_format>
</expert_analysis_request>`;

  let result: ExpertAnalysisResult | null = null;

  for await (const message of query({ prompt: analysisPrompt, options })) {
    if (message.type === 'result') {
      try {
        // Extract JSON from the response
        const jsonMatch = message.content.match(/\{[\s\S]*\}/);
        if (jsonMatch) {
          result = JSON.parse(jsonMatch[0]);
        }
      } catch (e) {
        console.error('Failed to parse analysis result:', e);
      }
    }
  }

  if (!result) {
    throw new Error('Failed to get analysis result');
  }

  return result;
}

/**
 * Implement a feature using multi-agent orchestration
 */
async function implementFeature(
  projectPath: string, 
  featureDescription: string
): Promise<void> {
  const options: ClaudeCodeOptions = {
    maxTurns: 30,
    workingDirectory: projectPath,
    systemPrompt: await fs.readFile(
      path.join(process.env.HOME!, '.dotfiles/claude-expert/CLAUDE.md'), 
      'utf-8'
    )
  };

  const implementationPrompt = `
<multi_agent_feature_request>
<thinking>
This is a complex feature implementation that requires coordinated effort from multiple specialized agents.
I'll use the multi-agent workflow pattern for optimal results.
</thinking>

Implement the following feature using the multi-agent orchestration pattern:
"${featureDescription}"

Follow the feature-development workflow:
1. Research Agent: Analyze existing patterns
2. Architecture Agent: Design the solution
3. Security Agent: Identify security requirements
4. Test Engineer: Plan comprehensive tests
5. Implementation Agent: Write the code
6. Documentation Agent: Update docs

Ensure all agents work in coordination and produce a complete, production-ready implementation.
</multi_agent_feature_request>`;

  const messages: string[] = [];

  for await (const message of query({ prompt: implementationPrompt, options })) {
    if (message.type === 'assistant') {
      messages.push(message.content);
      console.log('Claude:', message.content);
    } else if (message.type === 'result') {
      console.log('\n✅ Feature implementation complete!');
    }
  }
}

/**
 * Continuous monitoring and improvement
 */
async function continuousImprovement(projectPath: string): Promise<void> {
  console.log('🔄 Starting continuous improvement monitor...\n');

  while (true) {
    try {
      // Perform analysis
      console.log('📊 Running expert analysis...');
      const analysis = await performExpertAnalysis(projectPath);
      
      // Display findings
      console.log('\n📋 Analysis Summary:');
      console.log(analysis.summary);
      
      // Check for critical issues
      const criticalIssues = analysis.recommendations.filter(
        r => r.priority === 'critical'
      );
      
      if (criticalIssues.length > 0) {
        console.log('\n🚨 Critical issues found:');
        for (const issue of criticalIssues) {
          console.log(`  - ${issue.description}`);
        }
        
        // Auto-fix critical issues
        console.log('\n🔧 Attempting auto-fix...');
        for (const issue of criticalIssues) {
          await implementFeature(projectPath, `Fix: ${issue.description}`);
        }
      }
      
      // Wait before next analysis
      console.log('\n💤 Waiting 1 hour before next analysis...');
      await new Promise(resolve => setTimeout(resolve, 3600000)); // 1 hour
      
    } catch (error) {
      console.error('❌ Error in continuous improvement:', error);
      await new Promise(resolve => setTimeout(resolve, 300000)); // 5 min retry
    }
  }
}

/**
 * Batch processing multiple projects
 */
async function batchAnalysis(projectPaths: string[]): Promise<Map<string, ExpertAnalysisResult>> {
  const results = new Map<string, ExpertAnalysisResult>();
  
  // Process in parallel with concurrency limit
  const concurrencyLimit = 3;
  const chunks: string[][] = [];
  
  for (let i = 0; i < projectPaths.length; i += concurrencyLimit) {
    chunks.push(projectPaths.slice(i, i + concurrencyLimit));
  }
  
  for (const chunk of chunks) {
    const promises = chunk.map(async (projectPath) => {
      try {
        const result = await performExpertAnalysis(projectPath);
        results.set(projectPath, result);
        console.log(`✅ Completed analysis for ${path.basename(projectPath)}`);
      } catch (error) {
        console.error(`❌ Failed to analyze ${projectPath}:`, error);
      }
    });
    
    await Promise.all(promises);
  }
  
  return results;
}

/**
 * Generate comprehensive report
 */
async function generateReport(analyses: Map<string, ExpertAnalysisResult>): Promise<string> {
  let report = '# Expert Analysis Report\n\n';
  report += `Generated: ${new Date().toISOString()}\n\n`;
  
  for (const [projectPath, analysis] of analyses) {
    report += `## ${path.basename(projectPath)}\n\n`;
    report += `### Summary\n${analysis.summary}\n\n`;
    
    report += '### Key Findings\n';
    for (const [category, findings] of Object.entries(analysis.findings)) {
      if (findings.length > 0) {
        report += `\n#### ${category.charAt(0).toUpperCase() + category.slice(1)}\n`;
        findings.forEach(f => report += `- ${f}\n`);
      }
    }
    
    report += '\n### Recommendations\n';
    const grouped = analysis.recommendations.reduce((acc, rec) => {
      if (!acc[rec.priority]) acc[rec.priority] = [];
      acc[rec.priority].push(rec);
      return acc;
    }, {} as Record<string, typeof analysis.recommendations>);
    
    for (const priority of ['critical', 'high', 'medium', 'low']) {
      if (grouped[priority]?.length > 0) {
        report += `\n**${priority.toUpperCase()} Priority**\n`;
        grouped[priority].forEach(rec => {
          report += `- ${rec.description} (Effort: ${rec.effort})\n`;
        });
      }
    }
    
    report += '\n---\n\n';
  }
  
  return report;
}

// CLI Interface
async function main() {
  const args = process.argv.slice(2);
  const command = args[0];
  
  switch (command) {
    case 'analyze':
      if (!args[1]) {
        console.error('Usage: expert-sdk analyze <project-path>');
        process.exit(1);
      }
      const analysis = await performExpertAnalysis(args[1]);
      console.log(JSON.stringify(analysis, null, 2));
      break;
      
    case 'implement':
      if (!args[1] || !args[2]) {
        console.error('Usage: expert-sdk implement <project-path> "<feature-description>"');
        process.exit(1);
      }
      await implementFeature(args[1], args[2]);
      break;
      
    case 'monitor':
      if (!args[1]) {
        console.error('Usage: expert-sdk monitor <project-path>');
        process.exit(1);
      }
      await continuousImprovement(args[1]);
      break;
      
    case 'batch':
      if (args.length < 2) {
        console.error('Usage: expert-sdk batch <project1> <project2> ...');
        process.exit(1);
      }
      const results = await batchAnalysis(args.slice(1));
      const report = await generateReport(results);
      await fs.writeFile('expert-analysis-report.md', report);
      console.log('📄 Report saved to expert-analysis-report.md');
      break;
      
    default:
      console.log(`
Claude Expert SDK - Advanced Usage Examples

Commands:
  analyze <project>                    Run expert analysis on a project
  implement <project> "<description>"  Implement a feature using multi-agent
  monitor <project>                    Continuous improvement monitoring
  batch <project1> <project2> ...      Analyze multiple projects

Examples:
  npm run expert-sdk analyze ./my-project
  npm run expert-sdk implement ./my-project "Add OAuth2 authentication"
  npm run expert-sdk monitor ./production-app
  npm run expert-sdk batch ./app1 ./app2 ./app3
      `);
  }
}

// Run if executed directly
if (require.main === module) {
  main().catch(console.error);
}

// Export for use as library
export {
  performExpertAnalysis,
  implementFeature,
  continuousImprovement,
  batchAnalysis,
  generateReport,
  ExpertAnalysisResult
};