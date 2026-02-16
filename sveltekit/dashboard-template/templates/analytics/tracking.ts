import { nanoid } from 'nanoid';

type EventType = 'page_view' | 'widget_click' | 'widget_edit' | 'widget_remove' | 'widget_add';

interface EventData {
  page?: string;
  widgetId?: string;
  widgetType?: string;
  [key: string]: any;
}

interface AnalyticsEvent {
  id: string;
  userId: string;
  eventType: EventType;
  eventData: EventData;
  timestamp: Date;
}

// In-memory storage (replace with actual database in production)
let events: AnalyticsEvent[] = [];

export async function trackEvent(
  userId: string,
  eventType: EventType,
  eventData: EventData
): Promise<void> {
  const event: AnalyticsEvent = {
    id: nanoid(),
    userId,
    eventType,
    eventData,
    timestamp: new Date(),
  };

  events.push(event);

  // TODO: Replace with actual database insertion
  console.log('Analytics event tracked:', event);
}

export async function getPageViews(userId: string, days: number = 30): Promise<number> {
  const startDate = new Date();
  startDate.setDate(startDate.getDate() - days);

  return events.filter(
    event =>
      event.userId === userId &&
      event.eventType === 'page_view' &&
      event.timestamp >= startDate
  ).length;
}

export async function getWidgetStats(userId: string, days: number = 30): Promise<{
  widgetClicks: number;
  widgetEdits: number;
  widgetRemoves: number;
  widgetAdds: number;
}> {
  const startDate = new Date();
  startDate.setDate(startDate.getDate() - days);

  const userEvents = events.filter(
    event =>
      event.userId === userId &&
      event.timestamp >= startDate
  );

  return {
    widgetClicks: userEvents.filter(e => e.eventType === 'widget_click').length,
    widgetEdits: userEvents.filter(e => e.eventType === 'widget_edit').length,
    widgetRemoves: userEvents.filter(e => e.eventType === 'widget_remove').length,
    widgetAdds: userEvents.filter(e => e.eventType === 'widget_add').length,
  };
}

export async function getRecentEvents(userId: string, limit: number = 100): Promise<AnalyticsEvent[]> {
  return events
    .filter(event => event.userId === userId)
    .sort((a, b) => b.timestamp.getTime() - a.timestamp.getTime())
    .slice(0, limit);
}
