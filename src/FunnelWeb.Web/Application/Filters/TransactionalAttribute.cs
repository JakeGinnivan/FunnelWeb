﻿using System;
using System.Data;
using System.Web;
using System.Web.Mvc;
using Autofac;
using Autofac.Integration.Web;
using NHibernate;

namespace FunnelWeb.Web.Application.Filters
{
    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Method)]
    public class FunnelWebRequestAttribute : ActionFilterAttribute
    {
        public FunnelWebRequestAttribute()
        {
        }

        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            var session = DependencyResolver.Current.GetService<ISession>();
            session.BeginTransaction(IsolationLevel.Serializable);
        }

        public override void OnResultExecuted(ResultExecutedContext filterContext)
        {
            if (filterContext.Exception == null)
            {
                var session = DependencyResolver.Current.GetService<ISession>();
                session.Flush();
                session.Transaction.Commit();
            }
            else
            {
                var session = DependencyResolver.Current.GetService<ISession>();
                session.Clear();
                session.Transaction.Rollback();
            }
        }
    }
}