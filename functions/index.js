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
    const { resumeText } = req.body;
    if (!resumeText) {
      res.status(400).json({ error: "Missing resumeText in request body" });
      return;
    }

    // Get API key from environment variable
    const apiKey = process.env.GEMINI_API_KEY;
    if (!apiKey) {
      res.status(500).json({ error: "GEMINI_API_KEY environment variable is not set on the server." });
      return;
    }

    const model = "models/gemini-2.0-flash";
    const url = `https://generativelanguage.googleapis.com/v1beta/${model}:generateContent?key=${apiKey}`;

    const prompt = `Analyze this resume and provide structured feedback.

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

Scoring criteria:
- Formatting and structure (25 points)
- Keyword optimization (25 points)
- Content quality (25 points)
- Skills match (25 points)

Be honest but constructive. Focus on actionable improvements.`;

    const geminiPayload = {
      contents: [
        {
          parts: [
            { text: prompt }
          ]
        }
      ],
      generationConfig: {
        temperature: 0.2,
        maxOutputTokens: 2048,
        responseMimeType: "application/json",
      }
    };

    const response = await fetch(url, {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify(geminiPayload)
    });

    if (!response.ok) {
      const errorText = await response.text();
      res.status(response.status).json({
        error: `Gemini API responded with status ${response.status}`,
        details: errorText
      });
      return;
    }

    const data = await response.json();
    if (data.candidates && data.candidates.length > 0) {
      const contentText = data.candidates[0].content.parts[0].text;
      try {
        const parsedJson = JSON.parse(contentText);
        res.status(200).json(parsedJson);
      } catch (parseError) {
        res.status(500).json({
          error: "Failed to parse JSON response from Gemini",
          rawContent: contentText
        });
      }
    } else {
      res.status(500).json({ error: "Invalid response structure from Gemini API" });
    }
  } catch (error) {
    console.error("Error analyzing resume:", error);
    res.status(500).json({ error: error.message || "Internal Server Error" });
  }
});
