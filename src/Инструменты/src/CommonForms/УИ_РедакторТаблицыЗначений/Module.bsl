#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("СериализоватьВXML") Тогда
		//@skip-check unknown-form-parameter-access
		СериализоватьВXML = Параметры.СериализоватьВXML;
	КонецЕсли;
	
	Если Параметры.Свойство("ТаблицаЗначенийСтрокой") Тогда
		//@skip-check unknown-form-parameter-access
		Таблица = ТаблицаЗначенийИзСтроковогоПредставления(Параметры.ТаблицаЗначенийСтрокой, СериализоватьВXML);
	ИначеЕсли Параметры.Свойство("ХранилищеКонтейнераЗначения") Тогда 
		ВозвратХранилищаДляКонтейнераЗначения = Истина;
		
		//@skip-check unknown-form-parameter-access
		ХранилищеКонтейнера = Параметры.ХранилищеКонтейнераЗначения; //см. УИ_ОбщегоНазначенияКлиентСервер.НовыйХранилищеЗначенияТаблицыЗначений
		
		СериализоватьВXML = Ложь;
		Если ХранилищеКонтейнера <> Неопределено Тогда
			Таблица = ТаблицаЗначенийИзСтроковогоПредставления(ХранилищеКонтейнера.Значение, СериализоватьВXML);
		Иначе
			Таблица = Новый ТаблицаЗначений;
		КонецЕсли;
	КонецЕсли;

	ЗаполнитьКолонкиТаблицыЗначений(Таблица);
	СоздатьКолонкиТаблицыЗначенийФормы();
	ЗаполнитьТаблицуЗначенийФормыПоТаблице(Таблица);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыКолонкиТаблицы

&НаКлиенте
Процедура КолонкиТаблицыПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	ОбработатьИзменениеИмениКолонки(НоваяСтрока, ОтменаРедактирования, Отказ);
КонецПроцедуры
&НаКлиенте
Процедура КолонкиТаблицыТипЗначенияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ТекДанные=Элементы.КолонкиТаблицы.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ТекСтрока=Элементы.КолонкиТаблицы.ТекущаяСтрока;

	УИ_ОбщегоНазначенияКлиент.РедактироватьТип(ТекДанные.ТипЗначения, 1, СтандартнаяОбработка, ЭтотОбъект,
		Новый ОписаниеОповещения("КолонкиТаблицыТипЗначенияНачалоВыбораЗавершение", ЭтотОбъект,
		Новый Структура("ТекСтрока", ТекСтрока)));
КонецПроцедуры

&НаКлиенте
Процедура КолонкиТаблицыПослеУдаления(Элемент)
	СоздатьКолонкиТаблицыЗначенийФормы();
КонецПроцедуры

&НаКлиенте
Процедура КолонкиТаблицыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	СоздатьКолонкиТаблицыЗначенийФормы();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура Применить(Команда)
	СтруктураРезультата=РезультатТаблицаЗначенийВСтроку();
	
	Закрыть(СтруктураРезультата);	
КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ТаблицаЗначенийИзСтроковогоПредставления(СтроковоеПредставлениеТаблицы, СериализоватьвXML)

	Если СериализоватьВXML Тогда
		Попытка
			Таблица=УИ_ОбщегоНазначения.ЗначениеИзСтрокиXML(СтроковоеПредставлениеТаблицы);
		Исключение
			Таблица=Новый ТаблицаЗначений;
		КонецПопытки;
	Иначе
		Попытка
			Таблица=ЗначениеИзСтрокиВнутр(СтроковоеПредставлениеТаблицы);
		Исключение
			Таблица=Новый ТаблицаЗначений;
		КонецПопытки;
	КонецЕсли;
	Возврат Таблица;

КонецФункции

&НаСервере
Процедура ЗаполнитьКолонкиТаблицыЗначений(ТЗ)
	КолонкиТаблицы.Очистить();

	Для Каждого Колонка Из ТЗ.Колонки Цикл
		НС=КолонкиТаблицы.Добавить();
		НС.Имя=Колонка.Имя;
		НС.ТипЗначения=Колонка.ТипЗначения;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция ПолучитьНеотображаемыеНаКлиентеТипы()
	маТипы = Новый Массив;
	маТипы.Добавить(Тип("Тип"));
	маТипы.Добавить(Тип("МоментВремени"));
	маТипы.Добавить(Тип("Граница"));
	маТипы.Добавить(Тип("ХранилищеЗначения"));
	маТипы.Добавить(Тип("РезультатЗапроса"));
	Возврат маТипы;
КонецФункции

&НаСервере
Процедура СоздатьКолонкиТаблицыЗначенийФормы()

	маНеотображаемыеТипы = ПолучитьНеотображаемыеНаКлиентеТипы();

	МассивТекущихКолонокТаблицы=ПолучитьРеквизиты("ТаблицаЗначений");
	УжеСозданныеКолонки=Новый Соответствие;

	Для Каждого ТекРеквизит Из МассивТекущихКолонокТаблицы Цикл
		УжеСозданныеКолонки.Вставить(НРег(ТекРеквизит.Имя), ТекРеквизит);
	КонецЦикла;

	МассивУдаляемыхРеквизитов=Новый Массив;
	МассивДобавляемыхРеквизитов=Новый Массив;
	КолонкиДляПриведенияТипов=Новый Массив;
	Для Каждого ТекКолонка Из КолонкиТаблицы Цикл
		УжеСозданныйРеквизит=УжеСозданныеКолонки[НРег(ТекКолонка.Имя)];
		Если УжеСозданныйРеквизит = Неопределено Тогда
			МассивДобавляемыхРеквизитов.Добавить(Новый РеквизитФормы(ТекКолонка.Имя, ТекКолонка.ТипЗначения,
				"ТаблицаЗначений", , Истина));
		Иначе
			Если ТекКолонка.ТипЗначения <> УжеСозданныйРеквизит.ТипЗначения Тогда
				КолонкиДляПриведенияТипов.Добавить(ТекКолонка);
			КонецЕсли;
			УжеСозданныеКолонки.Удалить(НРег(ТекКолонка.Имя));
		КонецЕсли;
	КонецЦикла;

	Для Каждого КлючЗначение Из УжеСозданныеКолонки Цикл
		МассивУдаляемыхРеквизитов.Добавить(КлючЗначение.Ключ);
	КонецЦикла;

	ИзменитьРеквизиты(МассивДобавляемыхРеквизитов, МассивУдаляемыхРеквизитов);

	Для Каждого КолонкаДляПриведения Из КолонкиДляПриведенияТипов Цикл
		ПривестиТипКолонкиТаблицыЗначений(ЭтотОбъект, КолонкаДляПриведения);
	КонецЦикла;

	Для Каждого ТекКолонка Из КолонкиТаблицы Цикл
		ОписаниеЭлемента=УИ_РаботаСФормами.НовыйОписаниеРеквизитаЭлемента();
		ОписаниеЭлемента.Вставить("Имя", ТекКолонка.Имя);
		ОписаниеЭлемента.Вставить("ПутьКДанным", "ТаблицаЗначений." + ТекКолонка.Имя);
		ОписаниеЭлемента.Вставить("РодительЭлемента", Элементы.ТаблицаЗначений);
		УИ_РаботаСФормами.СоздатьЭлементПоОписанию(ЭтотОбъект, ОписаниеЭлемента);
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуЗначенийФормыПоТаблице(ТЗ)
	ТаблицаЗначений.Очистить();

	Для Каждого Стр Из ТЗ Цикл
		НС=ТаблицаЗначений.Добавить();
		ЗаполнитьЗначенияСвойств(НС, Стр);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьИзменениеИмениКолонки(НоваяСтрока, ОтменаРедактирования, Отказ)

	стрИмяКолонки = Элементы.КолонкиТаблицы.ТекущиеДанные.Имя;

	Если Не УИ_ОбщегоНазначенияКлиентСервер.ИмяПеременнойКорректно(стрИмяКолонки) Тогда
		ПоказатьПредупреждение( ,
			УИ_ОбщегоНазначенияКлиентСервер.ТекстПредупрежденияОНерпавильномИмениПеременной(),
			, Заголовок);
		Отказ = Истина;
		Возврат;
	КонецЕсли;

	маСтрокиИмени = КолонкиТаблицы.НайтиСтроки(Новый Структура("Имя", стрИмяКолонки));
	Если маСтрокиИмени.Количество() > 1 Тогда
		ПоказатьПредупреждение( , "Колонка с таким именем уже есть! Введите другое имя.", , Заголовок);
		Отказ = Истина;
		Возврат;
	КонецЕсли;

КонецПроцедуры
&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьМодификаторыТипа(ТипЗначения)

	маКвалификаторы = Новый Массив;

	Если ТипЗначения.СодержитТип(Тип("Строка")) Тогда
		стрКвалификаторыСтроки = "Длина " + ТипЗначения.КвалификаторыСтроки.Длина;
		маКвалификаторы.Добавить(Новый Структура("Тип, Квалификаторы", "Строка", стрКвалификаторыСтроки));
	КонецЕсли;

	Если ТипЗначения.СодержитТип(Тип("Дата")) Тогда
		стрКвалификаторыДаты = ТипЗначения.КвалификаторыДаты.ЧастиДаты;
		маКвалификаторы.Добавить(Новый Структура("Тип, Квалификаторы", "Дата", стрКвалификаторыДаты));
	КонецЕсли;

	Если ТипЗначения.СодержитТип(Тип("Число")) Тогда
		стрКвалификаторыДаты = "Знак " + ТипЗначения.КвалификаторыЧисла.ДопустимыйЗнак + " "
			+ ТипЗначения.КвалификаторыЧисла.Разрядность + "." + ТипЗначения.КвалификаторыЧисла.РазрядностьДробнойЧасти;
		маКвалификаторы.Добавить(Новый Структура("Тип, Квалификаторы", "Число", стрКвалификаторыДаты));
	КонецЕсли;

	фНуженЗаголовок = маКвалификаторы.Количество() > 1;

	стрКвалификаторы = "";
	Для Каждого стКвалификаторы Из маКвалификаторы Цикл
		стрКвалификаторы = ?(фНуженЗаголовок, стКвалификаторы.Тип + ": ", "") + стКвалификаторы.Квалификаторы + "; ";
	КонецЦикла;

	Возврат стрКвалификаторы;

КонецФункции

&НаКлиенте
Процедура КолонкиТаблицыТипЗначенияНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ТекДанные=КолонкиТаблицы.НайтиПоИдентификатору(ДополнительныеПараметры.ТекСтрока);
	ТекДанные.ТипЗначения=Результат;
	ТекДанные.Квалификаторы=ПолучитьМодификаторыТипа(ТекДанные.ТипЗначения);

	ПривестиТипКолонкиТаблицыЗначений(ЭтотОбъект, ТекДанные);
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПривестиТипКолонкиТаблицыЗначений(Форма, КолонкаДляПриведения)
	Для каждого Стр Из Форма.ТаблицаЗначений Цикл
		Стр[КолонкаДляПриведения.Имя]=КолонкаДляПриведения.ТипЗначения.ПривестиЗначение(Стр[КолонкаДляПриведения.Имя]);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция РезультатТаблицаЗначенийВСтроку()
	ТаблицаРезультата=РеквизитФормыВЗначение("ТаблицаЗначений");

	Если ВозвратХранилищаДляКонтейнераЗначения Тогда
		
	Иначе

		СтруктураРезультата=Новый Структура;
		Если СериализоватьВXML Тогда
			СтруктураРезультата.Вставить("Значение", УИ_ОбщегоНазначения.ЗначениеВСтрокуXML(ТаблицаРезультата));
		Иначе
			СтруктураРезультата.Вставить("Значение", ЗначениеВСтрокуВнутр(ТаблицаРезультата));
		КонецЕсли;
		СтруктураРезультата.Вставить("Представление", СтрШаблон("Строк: %1 Колонок: %2",
																ТаблицаРезультата.Количество(),
																ТаблицаРезультата.Колонки.Количество()));
		СтруктураРезультата.Вставить("КоличествоСтрок", ТаблицаРезультата.Количество());
		СтруктураРезультата.Вставить("КоличествоКолонок", ТаблицаРезультата.Колонки.Количество());
		Возврат СтруктураРезультата;
	КонецЕсли;
КонецФункции

#КонецОбласти