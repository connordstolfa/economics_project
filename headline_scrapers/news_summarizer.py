import google.genai as gemini
import os
from dotenv import load_dotenv
import time

load_dotenv()

def summarize_news_articles(articles):
    client = gemini.Client(api_key=os.getenv("GEMINI_API_KEY"))
    model_id = "gemini-2.0-flash"

    summaries = []

    # Personal to pass to the model.
    system_instruction = (
        "You are a senior economic analyst. Given a headline and abstract, "
        "provide a concise, 2-sentence summary. Sentence 1: Summarize the event. "
        "Sentence 2: Explain the potential impact on Inflation, GDP, or Interest Rates."
        "In the even that the article doesn't have to do with business or economics, state that the article is off topic."
    )

    for article in articles:
        time.sleep(5) # Wait 5 seconds to avoid rate limit issues.
        try:
            response = client.models.generate_content(
                model=model_id,
                contents=f"Headline: {article['headline']}\nAbstract: {article['abstract']}",
                config=gemini.types.GenerateContentConfig(
                    system_instruction=system_instruction,
                    temperature=0.2
                )
            )

            article['ai_summary'] = response.text.strip()
            summaries.append(article)

        except Exception as e:
            print(f"AI Summary failed for {article['headline']}: {e}")
            # Fallback to the original abstract so the UI doesn't break
            article['ai_summary'] = 'AI Summary Failed: ' + article['abstract']
            summaries.append(article)
    # return articles
