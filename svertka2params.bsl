///////////////////////////
//По двум параметрам
///////////////////////////
тзСобстНезавершенныеРЕПО.Сортировать("Инструмент");

//свертка по Инструмент и ВидСделки
тзИнструментыСделки = тзСобстНезавершенныеРЕПО.Скопировать();	
тзИнструментыСделки.Сортировать("Инструмент, ВидСделки");
тзИнструментыСделки.Свернуть("ВидСделки, Инструмент");

тзСверткаСобстНезавершенныеРЕПО = тзСобстНезавершенныеРЕПО.Скопировать();
тзСверткаСобстНезавершенныеРЕПО.Очистить();

Для каждого элм из тзИнструментыСделки цикл
	Отбор = Новый Структура;
	Отбор.Вставить("ВидСделки", элм.ВидСделки);
	Отбор.Вставить("Инструмент", элм.Инструмент);
	НайденныеСтроки = тзСобстНезавершенныеРЕПО.НайтиСтроки(Отбор);
	количествоЦБ = 0;
	ценаЦБ		 = 0;
	Если ЗначениеЗаполнено(НайденныеСтроки) тогда
		Для каждого Стр из НайденныеСтроки цикл
			количествоЦБ = количествоЦБ + Стр.Количество;//считаем сумму по данному инструменту
			Если Стр.Цена > ценаЦБ тогда//определяем maх цену по данному инструменту
				ценаЦБ = Стр.Цена; 
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	НоваяСтрока = тзСверткаСобстНезавершенныеРЕПО.Добавить();
	НоваяСтрока.ВидСделки 			= элм.ВидСделки;
	НоваяСтрока.Инструмент 			= элм.Инструмент;
	НоваяСтрока.ISIN				= НайденныеСтроки[0].ISIN;
	НоваяСтрока.КодИнструмента		= НайденныеСтроки[0].КодИнструмента;
	НоваяСтрока.Цена				= ценаЦБ;
	НоваяСтрока.ВалютаЦены			= НайденныеСтроки[0].ВалютаЦены;
	НоваяСтрока.Количество			= количествоЦБ;				
КонецЦикла;
