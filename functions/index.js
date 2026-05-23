require('dotenv').config();
const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.analyzeResume = functions.https.onRequest(async (req, res) => {
  // Set CORS headers
  res.set("Access-Control-Allow-Origin", "*");
  res.set("Access-Control-Allow-Methods", "POST, OPTIONS");
  res.set("Access-Control-Allow-Headers", "Content-Type, Authorization");

  // Handle preflight OPTIONS request
  if (req.method === "OPTIONS") {
    res.status(204).send("");
    return;
  }

  if (req.method !== "POST") {
    res.status(405).json({ error: "Method Not Allowed. Use POST." });
    return;
  }

  try {
    const { resumeText, targetJobTitle } = req.body;
    if (!resumeText) {
      res.status(400).json({ error: "Missing resumeText in request body" });
      return;
    }
    if (!targetJobTitle) {
      res.status(400).json({ error: "Missing targetJobTitle in request body" });
      return;
    }

    // Get API key from environment variable
    const apiKey = process.env.GROQ_API_KEY;
    if (!apiKey || apiKey === "gsk_placeholder_please_replace") {
      res.status(500).json({ error: "GROQ_API_KEY environment variable is not set or is still set to placeholder on the server." });
      return;
    }

    const model = "llama-3.3-70b-versatile";
    const url = "https://api.groq.com/openai/v1/chat/completions";

    const prompt = `Analyze this resume specifically in the context of the candidate applying for the target job title: "${targetJobTitle}". Provide structured feedback.

Resume Content:
${resumeText}

Return ONLY a JSON object with this exact structure:
{
  "atsScore": <number 0-100>,
  "strengths": [<string array>],
  "weaknesses": [<string array>],
  "suggestions": [<string array>],
  "missingSkills": [<string array>],
  "recommendedRoles": [<string array>],
  "summary": <string brief overview 1-2 sentences>
}

Scoring criteria and strict grading rules (evaluate against the target job title: "${targetJobTitle}"):
- Formatting and structure (max 25 points): Evaluate layout consistency, readability, sections, and clear contact info.
- Keyword optimization (max 25 points): Check for relevant industry keywords for "${targetJobTitle}", clear job titles, and standard terminology.
- Content quality and impact (max 25 points): Deduct points heavily if bullet points do not use the CAR (Context-Action-Result) format or lack metrics/numbers. If there are no quantifiable achievements (e.g. %, $, numbers, time saved), the maximum score for this section is 10/25.
- Skills and tech relevance (max 25 points): Match the candidate's core technologies and tools against standard professional expectations for a "${targetJobTitle}".

Strictness guidelines:
1. Do not inflate scores. An average, generic resume with standard descriptions and no metrics must score between 40 and 55.
2. Only exceptional, industry-leading resumes with clear metrics, strong formatting, zero grammatical errors, and high impact should score above 75.
3. If there are typos, poor structure, or lack of contact information, penalize heavily.
4. Calculate the final 'atsScore' mathematically as the sum of these four categories (0-100 total).`;

    const groqPayload = {
      messages: [
        {
          role: "user",
          content: prompt
        }
      ],
      model: model,
      temperature: 0.2,
      max_tokens: 2048,
      response_format: {
        type: "json_object"
      }
    };

    const response = await fetch(url, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${apiKey}`
      },
      body: JSON.stringify(groqPayload)
    });

    if (!response.ok) {
      const errorText = await response.text();
      res.status(response.status).json({
        error: `Groq API responded with status ${response.status}`,
        details: errorText
      });
      return;
    }

    const data = await response.json();
    if (data.choices && data.choices.length > 0) {
      const contentText = data.choices[0].message.content;
      try {
        const parsedJson = JSON.parse(contentText);
        res.status(200).json(parsedJson);
      } catch (parseError) {
        res.status(500).json({
          error: "Failed to parse JSON response from Groq",
          rawContent: contentText
        });
      }
    } else {
      res.status(500).json({ error: "Invalid response structure from Groq API" });
    }
  } catch (error) {
    console.error("Error analyzing resume:", error);
    res.status(500).json({ error: error.message || "Internal Server Error" });
  }
});
